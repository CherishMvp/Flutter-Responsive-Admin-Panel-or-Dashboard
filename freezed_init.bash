flutter pub add freezed_annotation
flutter pub add dev:build_runner
flutter pub add dev:freezed
# 如果你要使用 freezed 来生成 fromJson/toJson，则执行：
flutter pub add json_annotation
flutter pub add dev:json_serializable
# 为了运行代码生成器，执行以下命令：
# dart run build_runner build
# 使用方法和ts类型type类似 导入即可