import io
import os
import re
import shutil
import subprocess
import sys
import platform
import argparse
import ipaddress
import threading

# 全局变量存储用户输入
arguments = {}


def validate_project_name(name):
    """验证项目名称是否符合要求（只包含英文、数字和下划线）"""
    if not re.match(r'^[a-zA-Z0-9_]+$', name):
        raise argparse.ArgumentTypeError("项目名称只能包含英文、数字和下划线")
    return name


def validate_db_name(name):
    """验证数据库名称是否符合要求（只包含英文、数字和下划线）"""
    if not re.match(r'^[a-zA-Z0-9_]+$', name):
        raise argparse.ArgumentTypeError("数据库名称只能包含英文、数字和下划线")
    return name


def validate_api_url(url):
    """验证API地址是否为有效的IP或URL格式"""
    # 检查是否为有效的IP地址
    try:
        ipaddress.ip_address(url)
        return url
    except ValueError:
        pass

    # 检查是否为有效的URL (http:// 或 https:// 开头)
    if re.match(r'^https?://[^\s/$.?#].\S*$', url):
        return url

    raise argparse.ArgumentTypeError("API地址必须是有效的IP地址或URL (http:// 或 https:// 开头)")


def validate_target_dir(directory):
    """验证目标目录是否存在或可以创建"""
    if not os.path.exists(directory):
        try:
            os.makedirs(directory)
        except Exception as e:
            raise argparse.ArgumentTypeError(f"无法创建目录 '{directory}': {e}")
    return directory


def parse_arguments():
    """解析命令行参数"""
    parser = argparse.ArgumentParser(description="Flutter项目模板复制与配置工具")

    # 环境配置
    parser.add_argument("--flutter-bin",
                        help="Flutter SDK路径（可选，如果未设置则使用系统环境变量）")
    parser.add_argument("--project-name", required=True, type=validate_project_name,
                        help="项目名称（必填，英文数字下划线）")
    parser.add_argument("--dev-url", required=True, type=validate_api_url,
                        help="开发接口地址（必填）")
    parser.add_argument("--target-dir", required=True, type=validate_target_dir,
                        help="目标目录路径（必填）")
    parser.add_argument("--app-name",
                        help="应用名称（非必填，不填则与项目名一致）")
    parser.add_argument("--db-name", type=validate_db_name,
                        help="数据库名称（非必填，不填则与项目名一致）")
    parser.add_argument("--prod-url", type=validate_api_url,
                        help="生产接口地址（非必填，不填的话跟开发接口保持一致）")
    parser.add_argument("--description", default="",
                        help="项目描述（非必填，不填为空字符串）")
    parser.add_argument("--platforms",
                        help="要创建的平台，以逗号分隔 (例如: android,ios,web)")
    parser.add_argument("--android-package",
                        help="Android 包名 (例如: com.example.app)")
    parser.add_argument("--ios-bundle-id",
                        help="iOS Bundle ID (例如: com.example.app)")
    parser.add_argument("--macos-bundle-id",
                        help="MacOS Bundle ID (例如: com.example.app)")
    parser.add_argument("--open-when-finish", action="store_true",
                        help="完成后打开项目目录")

    args = parser.parse_args()
    arguments['flutter_bin'] = args.flutter_bin
    arguments['project_name'] = args.project_name
    arguments['app_name'] = args.app_name or args.project_name
    arguments['db_name'] = args.db_name or args.project_name
    arguments['dev_url'] = args.dev_url
    arguments['prod_url'] = args.prod_url or args.dev_url
    arguments['description'] = args.description
    arguments['target_dir'] = args.target_dir
    arguments['open_when_finish'] = args.open_when_finish
    # 处理平台配置
    if args.platforms:
        selected_platforms = [p.strip() for p in args.platforms.split(',')]
        if len(selected_platforms) > 0:
            arguments['platforms'] = {}
        for platform_name in selected_platforms:
            if platform_name == 'android' and args.android_package:
                arguments['platforms'][platform_name] = {
                    'package_name': args.android_package or f"com.{args.project_name.lower()}.app",
                }
            elif platform_name == 'ios' and args.ios_bundle_id:
                arguments['platforms'][platform_name] = {
                    'bundle_id': args.ios_bundle_id or f"com.{args.project_name.lower()}.app",
                }
            elif platform_name == 'macos' and args.macos_bundle_id:
                arguments['platforms'][platform_name] = {
                    'bundle_id': args.macos_bundle_id or f"com.{args.project_name.lower()}.app",
                }
            else:
                # 只添加平台但不配置特定参数
                arguments['platforms'][platform_name] = {}


def parse_user_input():
    """收集用户输入的项目信息"""
    # 收集项目名称（必填）
    while True:
        project_name = input("请输入项目名称（必填，英文数字下划线）: ").strip()
        if not project_name:
            print("项目名称不能为空！")
            continue
        if not validate_project_name(project_name):
            print("项目名称只能包含英文、数字和下划线！")
            continue
        arguments['project_name'] = project_name
        break

    # 收集应用名称（非必填，默认与项目名相同）
    app_name = input(f"请输入应用名称（非必填，默认为'{project_name}'）: ").strip()
    arguments['app_name'] = app_name if app_name else project_name

    # 收集数据库名称（非必填，默认与项目名相同）
    while True:
        db_name = input(f"请输入数据库名称（非必填，默认为'{project_name}'）: ").strip()
        db_name = db_name if db_name else project_name
        if not validate_db_name(db_name):
            print("数据库名称只能包含英文、数字和下划线！")
            continue
        arguments['db_name'] = db_name
        break

    # 收集开发接口地址（必填）
    while True:
        dev_url = input("请输入开发接口地址（必填）: ").strip()
        if not dev_url:
            print("开发接口地址不能为空！")
            continue
        try:
            validate_api_url(dev_url)
            arguments['dev_url'] = dev_url
            break
        except argparse.ArgumentTypeError as e:
            print(e)

    # 收集生产接口地址（非必填，默认与开发接口相同）
    while True:
        prod_url = input(f"请输入生产接口地址（非必填，默认为'{dev_url}'）: ").strip()
        if not prod_url:
            prod_url = dev_url
            arguments['prod_url'] = prod_url
            break
        try:
            validate_api_url(prod_url)
            arguments['prod_url'] = prod_url
            break
        except argparse.ArgumentTypeError as e:
            print(e)

    # 收集项目描述（非必填）
    description = input("请输入项目描述（非必填）: ").strip()
    arguments['description'] = description

    # 收集目标目录
    while True:
        target_dir = input("请输入目标目录路径（必填）: ").strip()
        if not target_dir:
            print("目标目录不能为空！")
            continue
        if not os.path.exists(target_dir):
            try:
                os.makedirs(target_dir)
            except Exception as e:
                print(f"无法创建目录 '{target_dir}': {e}")
                continue
        arguments['target_dir'] = target_dir
        break


def parse_user_input_platform_config():
    """收集平台配置信息"""
    print("\n请选择要创建的平台:")
    print("1. Android")
    print("2. iOS")
    print("3. Web")
    print("4. Windows")
    print("5. macOS")
    print("6. Linux")

    while True:
        choices = input("请输入要创建的平台编号（例如：1 2 3，或输入 all 选择全部）: ").strip().lower()

        if choices == 'all':
            selected_platforms = ['android', 'ios', 'web', 'windows', 'macos', 'linux']
            break

        selected_platforms = []
        for choice in choices.split():
            try:
                num = int(choice)
                if 1 <= num <= 6:
                    platform_map = {1: 'android', 2: 'ios', 3: 'web', 4: 'windows', 5: 'macos', 6: 'linux'}
                    selected_platforms.append(platform_map[num])
                else:
                    print(f"无效的选择: {num}")
            except ValueError:
                print(f"无效的输入: {choice}")

        if selected_platforms:
            break

    if len(selected_platforms) > 0:
        arguments['platforms'] = {}

    # 收集每个平台的配置
    for platform_name in selected_platforms:
        if platform_name == 'android':
            print(f"\n配置 {platform_name} 平台:")
            package_name = input("请输入包名 (例如: com.example.app): ").strip()
            while not re.match(r'^[a-zA-Z][a-zA-Z0-9_]*(?:\.[a-zA-Z][a-zA-Z0-9_]*)*$', package_name):
                print("包名格式不正确，请使用类似 com.example.app 的格式")
                package_name = input("请输入包名 (例如: com.example.app): ").strip()

            arguments['platforms'][platform_name] = {
                'package_name': package_name
            }

        elif platform_name == 'ios' or platform_name == 'macos':
            print(f"\n配置 {platform_name} 平台:")
            bundle_id = input("请输入 Bundle ID (例如: com.example.app): ").strip()
            while not re.match(r'^[a-zA-Z][a-zA-Z0-9_]*(?:\.[a-zA-Z][a-zA-Z0-9_]*)*$', bundle_id):
                print("Bundle ID 格式不正确，请使用类似 com.example.app 的格式")
                bundle_id = input("请输入 Bundle ID (例如: com.example.app): ").strip()

            arguments['platforms'][platform_name] = {
                'bundle_id': bundle_id
            }
        else:
            # 其他平台可以根据需要添加配置选项
            arguments['platforms'][platform_name] = {}


def read_stream(stream, _):
    for line in stream:
        print(f"{line.decode().strip()}")


def execute_command(command):
    """执行命令（在项目下）"""
    print(f"\n执行命令: {' '.join(command)}")
    try:
        process = subprocess.Popen(command, cwd=arguments.get('project_dir'),
                                   shell=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE, bufsize=-1)
        # 创建两个线程分别处理标准输出和标准错误
        stdout_thread = threading.Thread(target=read_stream, args=(process.stdout, "stdout"))
        stderr_thread = threading.Thread(target=read_stream, args=(process.stderr, "stderr"))
        # 设置为守护线程，主程序退出时自动终止
        stdout_thread.daemon = True
        stderr_thread.daemon = True
        # 启动线程
        stdout_thread.start()
        stderr_thread.start()
        # 等待进程结束
        process.wait()
        # 等待所有线程完成
        stdout_thread.join()
        stderr_thread.join()
        # 检查返回码
        if process.returncode != 0:
            raise subprocess.CalledProcessError(process.returncode, command)
    except subprocess.CalledProcessError as e:
        print(f"命令执行失败: {e}")
        print(e.stderr)
        return False

    return True


def execute_flutter_command(command):
    """执行flutter命令"""
    flutter_bin = arguments.get('flutter_bin')
    command.insert(0, os.path.join(flutter_bin, 'flutter') if flutter_bin else "flutter")
    return execute_command(command)


def execute_dart_command(command):
    """执行dart命令"""
    flutter_bin = arguments.get('flutter_bin')
    command.insert(0, os.path.join(flutter_bin, 'dart') if flutter_bin else "dart")
    return execute_command(command)


def replace_placeholders_in_file(file_path, replacements):
    """替换文件中的占位符"""
    try:
        content = ""
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()

        # 执行替换
        for placeholder, value in replacements.items():
            content = content.replace(placeholder, value)

        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(content)
    except Exception as e:
        print(f"处理文件 '{file_path}' 时出错: {e}")


def replace_placeholders():
    """替换项目模板中的占位符"""
    replacements = {
        "${jtech_base_project_name}$": arguments.get('project_name'),
        "${jtech_base_app_name}$": arguments.get('app_name'),
        "${jtech_base_db_name}$": arguments.get('db_name'),
        "${jtech_base_dev_url}$": arguments.get('dev_url'),
        "${jtech_base_prod_url}$": arguments.get('prod_url'),
        "${jtech_base_description}$": arguments.get('description')
    }
    # 处理目录中的所有文件，替换占位符
    for root, dirs, files in os.walk(arguments.get('project_dir')):
        for file in files:
            file_path = os.path.join(root, file)
            replace_placeholders_in_file(file_path, replacements)


def execute_init_commands():
    """执行初始化命令"""
    return all([
        execute_flutter_command(["pub", "get"]),
        execute_flutter_command(["pub", "add", "jtech_base"]),
        execute_dart_command(["run", "build_runner", "build"])
    ])


def configure_platforms():
    """配置平台"""
    if not arguments.get('platforms'):
        print("\n没有选择任何平台，跳过平台配置")
        return True

    project_dir = arguments.get('project_dir')
    for platform_name, config in arguments.get('platforms').items():
        print(f"\n*st:配置 {platform_name} 平台...")
        if platform_name == 'android':
            # 配置 Android 平台
            android_dir = os.path.join(project_dir, 'android')
            if not os.path.exists(android_dir):
                if not execute_flutter_command(
                        ["create", "--platforms=android", "--org", config.get('package_name'), "."]):
                    print(f"*fst:创建 {platform_name} 平台失败")
                    continue
        elif platform_name == 'ios':
            # 配置 iOS 平台
            ios_dir = os.path.join(project_dir, 'ios')
            if not os.path.exists(ios_dir):
                print(f"创建 {platform_name} 平台...")
                if not execute_flutter_command(
                        ["create", "--platforms=ios", "--org", config.get('bundle_id'), "."]):
                    print(f"*fst:创建 {platform_name} 平台失败")
                    continue
        elif platform_name == 'macos':
            # 配置 macOS 平台
            macos_dir = os.path.join(project_dir, 'macos')
            if not os.path.exists(macos_dir):
                if not execute_flutter_command(
                        ["create", "--platforms=macos", "--org", config.get('bundle_id'), "."]):
                    print(f"*fst:创建 {platform_name} 平台失败")
                    continue
        else:
            platform_dir = os.path.join(project_dir, platform_name)
            if not os.path.exists(platform_dir):
                if not execute_flutter_command(["create", "--platforms=" + platform_name, "."]):
                    print(f"*fst:创建 {platform_name} 平台失败")
                    continue
        print(f"{platform_name} 平台配置完成！")
    return True


def open_directory(directory):
    """打开目录"""
    try:
        if platform.system() == 'Windows':
            os.startfile(directory)
        elif platform.system() == 'Darwin':  # macOS
            subprocess.run(['open', directory], check=True, text=True, capture_output=True, shell=True)
        else:  # Linux
            subprocess.run(['xdg-open', directory], check=True, text=True, capture_output=True, shell=True)
        return True
    except Exception as e:
        print(f"无法打开目录: {e}")
        return False


def main():
    sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding="utf-8")
    """主函数"""
    print("=" * 50)
    print("Flutter项目模板复制与配置工具")
    print("=" * 50)

    try:
        # 尝试解析命令行参数
        parse_arguments()
    except SystemExit:
        # 如果参数解析失败，使用交互式输入
        parse_user_input()

    # 模板源目录
    cwd = os.getcwd()
    if os.path.basename(cwd).lower() == "script":
        arguments["template_dir"] = os.path.join(cwd, "..", ".template")
    elif os.path.basename(cwd).lower() == "dist":
        arguments["template_dir"] = os.path.join(cwd, "..", "..", ".template")
    else:
        arguments["template_dir"] = os.path.join(cwd, ".template")

    # 目标项目目录
    arguments["project_dir"] = os.path.join(arguments.get('target_dir'), arguments.get('project_name'))

    try:
        # 复制模板目录到目标位置
        print(f"\n*st:正在复制模板到 {arguments.get('project_dir')}...")
        shutil.copytree(arguments.get('template_dir'), arguments.get('project_dir'), dirs_exist_ok=True)

        # 替换文件中的占位符
        print("\n*st:正在替换文件中的占位符...")
        replace_placeholders()

        # 执行必要的命令
        print("\n*st:正在执行初始化命令...")
        if execute_init_commands():
            print("\n项目初始化完成！")
        else:
            print("\n*fst:项目初始化过程中出现错误，请检查以上输出。")

        # 收集平台配置信息（如果尚未收集）
        if not arguments.get('platforms'):
            print("\n接下来配置平台...")
            parse_user_input_platform_config()

        # 配置平台
        print("\n*st:开始配置平台信息")
        if configure_platforms():
            print("\n平台配置完成！")
        else:
            print("\n*fst:平台配置过程中出现错误，请检查以上输出。")

        # 询问是否打开项目目录，除非通过命令行指定不打开
        open_dir = arguments.get('open_when_finish')
        if open_dir is not None:
            if open_dir:
                print("\n*st:打开项目目录")
                open_directory(arguments.get('project_dir'))
        else:
            open_dir = input("\n是否打开项目目录？(y/n): ").strip().lower()
            if open_dir == 'y':
                open_directory(arguments.get('project_dir'))
                print(f"已打开项目目录: {arguments.get('project_dir')}")

        print("\n创建完成！")

    except Exception as e:
        print(f"*fst:发生错误: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
