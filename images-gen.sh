#!/usr/bin/env bash

# java -jar ./tools/res_generator.jar type=icon icon_folder_path=./assets/images icon_code_file_path=./lib/res/images.dart class_name=HHGImages icon_path_prefix=assets/images/ icon_file_name_prefix=img_ standardize_file_name=true

./tools/generator_assets -folder-path=./assets/images -file-name=images.dart -prefix=img_ -class-name=NSGImages -output=./lib/res/