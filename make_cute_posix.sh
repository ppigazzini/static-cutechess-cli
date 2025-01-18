#!/bin/sh
# https://wiki.qt.io/Building_Qt_6_from_Git
# https://wiki.qt.io/Building_Qt_5_from_Git
# http://doc.qt.io/qt-5/linux-deployment.html
# https://github.com/qt/qt5

# install packages
# apk update && apk add sudo perl python3 git zip make cmake ninja g++ linux-headers mesa-dev
# brew install ninja

# configure
n_jobs=6
base_path="$PWD"
qt_source="$base_path"/qt5
qt_build="$base_path"/qt5-build
qt_install="$base_path"/qt5-static
cute_source="$base_path"/cutechess
cute_build="$base_path"/cutechess-build

mkdir -p "$qt_source" "$qt_build" "$qt_install" "$cute_source" "$cute_build"
sudo ln -sf "$qt_install" /opt/qt5-static

# build Qt static
git clone https://code.qt.io/qt/qt5.git "$qt_source"
cd "$qt_source"
git switch --detach v5.15.16-lts-lgpl
# use the default if the fast build should stop working
# perl init-repository --module-subset=default,-qtwebengine
perl init-repository --module-subset=qtbase,qtsvg
cd "$qt_build"
"$qt_source"/configure -static -release -opensource -confirm-license -prefix "$qt_install" -nomake examples -nomake tests -nomake tools

make -j "$n_jobs"
make install

# build cutechess-cli
git clone https://github.com/cutechess/cutechess.git "$cute_source"

# checkout the tag of interest
cd "$cute_source"
git fetch -p --tags --all
# latest tag
tag=$(git describe --tags `git rev-list --tags --max-count=1`)
tag='v1.3.1'
tag="v1.4.0-beta3"
git switch --detach "$tag"
git log --oneline -n 5 > "$cute_build"/cutechess.git.log

# set static build
sed -i '/set_target_properties(cli PROPERTIES OUTPUT_NAME cutechess-cli)/a set_target_properties(cli PROPERTIES LINK_SEARCH_START_STATIC ON)\nset_target_properties(cli PROPERTIES LINK_SEARCH_END_STATIC ON)\ntarget_link_options(cli PRIVATE -static-libgcc -static-libstdc++ -static)' "$cute_source"/CMakeLists.txt

# make static build
cd "$cute_build"
cmake -G Ninja "$cute_source" -DCMAKE_BUILD_TYPE=Release
cmake --build . -j $n_jobs
strip cutechess-cli
./cutechess-cli --version > cutechess-cli.readme
printf "source code:\nhttps://github.com/cutechess/cutechess\n" >> cutechess-cli.readme
zip -j9 "$base_path"/cutechess-cli.zip cutechess-cli cutechess-cli.readme

# run tests
echo "testing cutechess..."
for file in "$cute_build"/test_*; do
    if [ -x "$file" ] && [ ! -d "$file" ]; then
        base=$(basename -- "$file")
        "$file" > "$base".log 2>&1 &
    fi
done
wait
for file in "$cute_build"/test_*.log; do
    tail "$file"
done
