#!/usr/bin/env bash

set -eu

function usage() {
  cat << EOF
  usage: bootstrap.sh PROJECT_NAME
  Example: bootstrap.sh MyAwesomeProject
EOF
}

if [ $# -ne 1 ]; then
  echo "ERROR: Need PROJECT_NAME!"
  usage
  exit 1
fi

base="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

new_project_name=$1
new_project_name_lower=$(echo "${new_project_name}" | awk '{print tolower($0)}')
new_project_name_upper=$(echo "${new_project_name}" | awk '{print toupper($0)}')

demo_project_name=$(grep "project(.*)" "${base}/CMakeLists.txt" | awk '{print $1}' | awk -F'(' '{print $2}')
demo_project_name_lower=$(echo "${demo_project_name}" | awk '{print tolower($0)}')
demo_project_name_upper=$(echo "${demo_project_name}" | awk '{print toupper($0)}')

find "${base}" -type f \( -name "CMakeLists.txt" -or -name "*.cmake" -or -name "docker-compose.yml" \
  -or -name "devcontainer.json" -or -name ".gitignore" -or -name "version.h.in" -or -name "CMakePresets.json" \
  -or -name "*.h" -or -name "*.cpp" \) \
  -exec sed -i.bak "s/${demo_project_name}/${new_project_name}/g" "{}" \;
find "${base}" -type f \( -name "CMakeLists.txt" -or -name "*.cmake" -or -name "docker-compose.yml" \
  -or -name "devcontainer.json" -or -name ".gitignore" -or -name "version.h.in" -or -name "CMakePresets.json" \
  -or -name "*.h" -or -name "*.cpp" \) -exec \
  sed -i.bak "s/${demo_project_name_upper}/${new_project_name_upper}/g" {} \;
find "${base}" -type f \( -name "CMakeLists.txt" -or -name "*.cmake" -or -name "docker-compose.yml" \
  -or -name "devcontainer.json" -or -name ".gitignore" -or -name "version.h.in" -or -name "CMakePresets.json" \
  -or -name "*.h" -or -name "*.cpp" \) -exec \
  sed -i.bak "s/${demo_project_name_lower}/${new_project_name_lower}/g" {} \;

sed -i.bak "s/${demo_project_name}/${new_project_name}/g" "${base}/README.md"

find "${base}" -type f -name "*.bak" -exec /usr/bin/env rm -f "{}" \;

/usr/bin/env rm -rf "${base}/src/${new_project_name_lower}"
mv -f "${base}/src/${demo_project_name_lower}" "${base}/src/${new_project_name_lower}"

/usr/bin/env rm -f "${base}/cmake/${new_project_name}Config.cmake.in"
mv -f "${base}/cmake/${demo_project_name}Config.cmake.in" "${base}/cmake/${new_project_name}Config.cmake.in"
