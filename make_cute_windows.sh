#!/bin/bash
# https://stackoverflow.com/questions/1011197/qt-static-linking-and-deployment
# https://www.msys2.org/docs/cmake/

# install packages
# pacman -S --needed --noconfirm zip git mingw-w64-i686-cmake mingw-w64-i686-gcc mingw-w64-i686-qt5-static
# pacman -S --needed --noconfirm zip git mingw-w64-x86_64-cmake mingw-w64-x86_64-gcc mingw-w64-x86_64-qt5-static

# configure
n_jobs=6
base_path="$PWD"
cute_source="$base_path"/cutechess
cute_build="$base_path"/cutechess-build

mkdir -p "$cute_source" "$cute_build"

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

# use static libraries with QT
sed -i '/find_package(Qt6 COMPONENTS ${QT_COMPONENTS} Core5Compat QUIET)/i list(PREPEND CMAKE_FIND_LIBRARY_SUFFIXES .a .lib)' "$cute_source"/CMakeLists.txt

# make static build
cd "$cute_build"
cmake -G Ninja "$cute_source" -DCMAKE_BUILD_TYPE=Release -DCMAKE_EXE_LINKER_FLAGS="-static"
cmake --build . -j "$n_jobs"
strip cutechess-cli.exe
strip cutechess.exe
./cutechess-cli.exe --version > cutechess-cli.readme
printf "source code:\nhttps://github.com/cutechess/cutechess\n" >> cutechess-cli.readme
zip -j9 "$base_path"/cutechess-cli.zip cutechess-cli.exe cutechess-cli.readme

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
