import os
import re
import shutil
import subprocess
import sys
import platform
import argparse
import ipaddress


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
    if re.match(r'^https?://[^\s/$.?#].[^\s]*$', url):
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


def get_user_input():
    """收集用户输入的项目信息"""
    inputs = {}

    # 收集项目名称（必填）
    while True:
        project_name = input("请输入项目名称（必填，英文数字下划线）: ").strip()
        if not project_name:
            print("项目名称不能为空！")
            continue
        if not validate_project_name(project_name):
            print("项目名称只能包含英文、数字和下划线！")
            continue
        inputs['project_name'] = project_name
        break

    # 收集应用名称（非必填，默认与项目名相同）
    app_name = input(f"请输入应用名称（非必填，默认为'{project_name}'）: ").strip()
    inputs['app_name'] = app_name if app_name else project_name

    # 收集数据库名称（非必填，默认与项目名相同）
    while True:
        db_name = input(f"请输入数据库名称（非必填，默认为'{project_name}'）: ").strip()
        db_name = db_name if db_name else project_name
        if not validate_db_name(db_name):
            print("数据库名称只能包含英文、数字和下划线！")
            continue
        inputs['db_name'] = db_name
        break

    # 收集开发接口地址（必填）
    while True:
        dev_url = input("请输入开发接口地址（必填）: ").strip()
        if not dev_url:
            print("开发接口地址不能为空！")
            continue
        try:
            validate_api_url(dev_url)
            inputs['dev_url'] = dev_url
            break
        except argparse.ArgumentTypeError as e:
            print(e)

    # 收集生产接口地址（非必填，默认与开发接口相同）
    while True:
        prod_url = input(f"请输入生产接口地址（非必填，默认为'{dev_url}'）: ").strip()
        if not prod_url:
            prod_url = dev_url
            inputs['prod_url'] = prod_url
            break
        try:
            validate_api_url(prod_url)
            inputs['prod_url'] = prod_url
            break
        except argparse.ArgumentTypeError as e:
            print(e)

    # 收集项目描述（非必填）
    description = input("请输入项目描述（非必填）: ").strip()
    inputs['description'] = description

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
        inputs['target_dir'] = target_dir
        break

    return inputs


def get_platform_config():
    """收集平台配置信息"""
    platforms = {}

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

    # 收集每个平台的配置
    for platform_name in selected_platforms:
        platform_config = {}

        if platform_name == 'android':
            print(f"\n配置 {platform_name} 平台:")
            package_name = input("请输入包名 (例如: com.example.app): ").strip()
            while not re.match(r'^[a-zA-Z][a-zA-Z0-9_]*(?:\.[a-zA-Z][a-zA-Z0-9_]*)*$', package_name):
                print("包名格式不正确，请使用类似 com.example.app 的格式")
                package_name = input("请输入包名 (例如: com.example.app): ").strip()

            platform_config['package_name'] = package_name

        elif platform_name == 'ios':
            print(f"\n配置 {platform_name} 平台:")
            bundle_id = input("请输入 Bundle ID (例如: com.example.app): ").strip()
            while not re.match(r'^[a-zA-Z][a-zA-Z0-9_]*(?:\.[a-zA-Z][a-zA-Z0-9_]*)*$', bundle_id):
                print("Bundle ID 格式不正确，请使用类似 com.example.app 的格式")
                bundle_id = input("请输入 Bundle ID (例如: com.example.app): ").strip()

            platform_config['bundle_id'] = bundle_id

        elif platform_name == 'web':
            print(f"\n配置 {platform_name} 平台:")
            web_renderer = input("请选择 Web 渲染器 (1: HTML, 2: CanvasKit): ").strip()
            while web_renderer not in ['1', '2']:
                print("无效的选择，请输入 1 或 2")
                web_renderer = input("请选择 Web 渲染器 (1: HTML, 2: CanvasKit): ").strip()

            platform_config['web_renderer'] = 'html' if web_renderer == '1' else 'canvaskit'

        # 其他平台可以根据需要添加配置选项

        platforms[platform_name] = platform_config

    return platforms


def replace_placeholders_in_file(file_path, replacements):
    """替换文件中的占位符"""
    try:
        with open(file_path, 'r', encoding='utf-8') as file:
            content = file.read()

        # 执行替换
        for placeholder, value in replacements.items():
            content = content.replace(placeholder, value)

        with open(file_path, 'w', encoding='utf-8') as file:
            file.write(content)
    except Exception as e:
        print(f"处理文件 '{file_path}' 时出错: {e}")


def process_directory(directory, replacements):
    """处理目录中的所有文件，替换占位符"""
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            replace_placeholders_in_file(file_path, replacements)


def execute_commands(project_dir):
    """执行必要的命令"""
    commands = [
        ["flutter", "pub", "get"],
        ["flutter", "pub", "add", "jtech_base"],
        ["dart", "run", "build_runner", "build"]
    ]

    for cmd in commands:
        print(f"\n执行命令: {' '.join(cmd)}")
        try:
            result = subprocess.run(cmd, cwd=project_dir, check=True, text=True, capture_output=True, shell=True)
            print(result.stdout)
        except subprocess.CalledProcessError as e:
            print(f"命令执行失败: {e}")
            print(e.stderr)
            return False

    return True


def configure_platforms(project_dir, platforms):
    """配置选定的平台"""
    if not platforms:
        print("\n没有选择任何平台，跳过平台配置")
        return True

    print("\n开始配置平台...")

    for platform_name, config in platforms.items():
        print(f"\n配置 {platform_name} 平台...")

        if platform_name == 'android':
            # 配置 Android 平台
            android_dir = os.path.join(project_dir, 'android')
            if not os.path.exists(android_dir):
                print(f"创建 {platform_name} 平台...")
                subprocess.run(
                    ["flutter", "create", "--platforms=android", "--org", config['package_name'].rsplit('.', 1)[0],
                     "."], cwd=project_dir, check=True, text=True, capture_output=True, shell=True)

            # 修改 AndroidManifest.xml 中的 package
            manifest_path = os.path.join(android_dir, 'app', 'src', 'main', 'AndroidManifest.xml')
            if os.path.exists(manifest_path):
                with open(manifest_path, 'r', encoding='utf-8') as file:
                    content = file.read()

                # 替换 package 属性
                content = re.sub(r'package="[^"]+"', f'package="{config["package_name"]}"', content)

                with open(manifest_path, 'w', encoding='utf-8') as file:
                    file.write(content)

        elif platform_name == 'ios':
            # 配置 iOS 平台
            ios_dir = os.path.join(project_dir, 'ios')
            if not os.path.exists(ios_dir):
                print(f"创建 {platform_name} 平台...")
                subprocess.run(["flutter", "create", "--platforms=ios", "."], cwd=project_dir, check=True, text=True,
                               capture_output=True, shell=True)

            # 修改 Info.plist 中的 CFBundleIdentifier
            info_plist_path = os.path.join(ios_dir, 'Runner', 'Info.plist')
            if os.path.exists(info_plist_path):
                with open(info_plist_path, 'r', encoding='utf-8') as file:
                    content = file.read()

                # 替换 CFBundleIdentifier
                content = re.sub(r'<key>CFBundleIdentifier</key>\s*<string>[^<]+</string>',
                                 f'<key>CFBundleIdentifier</key>\n\t<string>{config["bundle_id"]}</string>', content)

                with open(info_plist_path, 'w', encoding='utf-8') as file:
                    file.write(content)

        elif platform_name == 'web':
            # 配置 Web 平台
            web_dir = os.path.join(project_dir, 'web')
            if not os.path.exists(web_dir):
                print(f"创建 {platform_name} 平台...")
                subprocess.run(["flutter", "create", "--platforms=web", "."], cwd=project_dir, check=True, text=True,
                               capture_output=True, shell=True)

            # 修改 web/index.html 中的 title
            index_path = os.path.join(web_dir, 'index.html')
            if os.path.exists(index_path):
                with open(index_path, 'r', encoding='utf-8') as file:
                    content = file.read()

                # 替换 title
                content = re.sub(r'<title>[^<]+</title>', f'<title>{config.get("title", "Flutter App")}</title>',
                                 content)

                with open(index_path, 'w', encoding='utf-8') as file:
                    file.write(content)

            # 根据选择的渲染器更新项目
            print(f"Web 平台使用 {config['web_renderer']} 渲染器")

        elif platform_name == 'windows':
            # 配置 Windows 平台
            windows_dir = os.path.join(project_dir, 'windows')
            if not os.path.exists(windows_dir):
                print(f"创建 {platform_name} 平台...")
                subprocess.run(["flutter", "create", "--platforms=windows", "."], cwd=project_dir, check=True,
                               text=True,
                               capture_output=True, shell=True)

            # 配置 Windows 特定设置
            print(f"Windows 平台配置完成")

        elif platform_name == 'macos':
            # 配置 macOS 平台
            macos_dir = os.path.join(project_dir, 'macos')
            if not os.path.exists(macos_dir):
                print(f"创建 {platform_name} 平台...")
                subprocess.run(["flutter", "create", "--platforms=macos", "."], cwd=project_dir, check=True, text=True,
                               capture_output=True, shell=True)

            # 修改 Info.plist 中的 CFBundleIdentifier
            info_plist_path = os.path.join(macos_dir, 'Runner', 'Info.plist')
            if os.path.exists(info_plist_path):
                with open(info_plist_path, 'r', encoding='utf-8') as file:
                    content = file.read()

                # 替换 CFBundleIdentifier
                content = re.sub(r'<key>CFBundleIdentifier</key>\s*<string>[^<]+</string>',
                                 f'<key>CFBundleIdentifier</key>\n\t<string>{config.get("bundle_id", "Flutter App")}</string>',
                                 content)

                with open(info_plist_path, 'w', encoding='utf-8') as file:
                    file.write(content)

            # 配置 macOS 特定设置
            print(f"macOS 平台配置完成")

        elif platform_name == 'linux':
            # 配置 Linux 平台
            linux_dir = os.path.join(project_dir, 'linux')
            if not os.path.exists(linux_dir):
                print(f"创建 {platform_name} 平台...")
                subprocess.run(["flutter", "create", "--platforms=linux", "."], cwd=project_dir, check=True, text=True,
                               capture_output=True, shell=True)

            # 配置 Linux 特定设置
            print(f"Linux 平台配置完成")

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


def parse_arguments():
    """解析命令行参数"""
    parser = argparse.ArgumentParser(description="Flutter项目模板复制与配置工具")

    # 必需参数
    parser.add_argument("--project-name", required=True, type=validate_project_name,
                        help="项目名称（必填，英文数字下划线）")
    parser.add_argument("--dev-url", required=True, type=validate_api_url,
                        help="开发接口地址（必填）")
    parser.add_argument("--target-dir", required=True, type=validate_target_dir,
                        help="目标目录路径（必填）")

    # 可选参数
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
    parser.add_argument("--android-language", choices=['kotlin', 'java'],
                        help="Android 开发语言 (kotlin 或 java)")
    parser.add_argument("--ios-bundle-id",
                        help="iOS Bundle ID (例如: com.example.app)")
    parser.add_argument("--ios-language", choices=['swift', 'objective-c'],
                        help="iOS 开发语言 (swift 或 objective-c)")
    parser.add_argument("--web-renderer", choices=['html', 'canvaskit'],
                        help="Web 渲染器 (html 或 canvaskit)")
    parser.add_argument("--no-open", action="store_true",
                        help="完成后不打开项目目录")

    return parser.parse_args()


def main():
    """主函数"""
    print("=" * 50)
    print("Flutter项目模板复制与配置工具")
    print("=" * 50)

    # 尝试解析命令行参数
    try:
        args = parse_arguments()
        # 如果提供了命令行参数，使用这些参数而不是用户输入
        use_args = True
    except SystemExit:
        # 如果参数解析失败，使用交互式输入
        use_args = False

    if use_args:
        # 使用命令行参数
        inputs = {
            'project_name': args.project_name,
            'app_name': args.app_name or args.project_name,
            'db_name': args.db_name or args.project_name,
            'dev_url': args.dev_url,
            'prod_url': args.prod_url or args.dev_url,
            'description': args.description,
            'target_dir': args.target_dir,
            'no_open': args.no_open
        }

        # 处理平台配置
        platforms = {}
        if args.platforms:
            selected_platforms = [p.strip() for p in args.platforms.split(',')]

            for platform_name in selected_platforms:
                if platform_name == 'android' and (args.android_package or args.android_language):
                    platforms['android'] = {
                        'package_name': args.android_package or f"com.{args.project_name.lower()}.app",
                        'language': args.android_language or 'kotlin'
                    }
                elif platform_name == 'ios' and (args.ios_bundle_id or args.ios_language):
                    platforms['ios'] = {
                        'bundle_id': args.ios_bundle_id or f"com.{args.project_name.lower()}.app",
                        'language': args.ios_language or 'swift'
                    }
                elif platform_name == 'web' and args.web_renderer:
                    platforms['web'] = {
                        'web_renderer': args.web_renderer
                    }
                else:
                    # 只添加平台但不配置特定参数
                    platforms[platform_name] = {}

        print("\n使用以下参数:")
        for key, value in inputs.items():
            if key != 'no_open':
                print(f"{key}: {value}")

        if platforms:
            print("\n配置平台:")
            for platform_name, config in platforms.items():
                print(f"- {platform_name}: {config}")
    else:
        # 收集用户输入
        inputs = get_user_input()
        platforms = None

    # 设置替换映射
    replacements = {
        "${jtech_base_project_name}$": inputs['project_name'],
        "${jtech_base_app_name}$": inputs['app_name'],
        "${jtech_base_db_name}$": inputs['db_name'],
        "${jtech_base_dev_url}$": inputs['dev_url'],
        "${jtech_base_prod_url}$": inputs['prod_url'],
        "${jtech_base_description}$": inputs['description']
    }

    # 模板源目录
    current_dir = os.path.basename(os.getcwd())
    if current_dir.lower() == "script":
        template_dir = os.path.join(os.getcwd(), "..", ".template")
    else:
        template_dir = os.path.join(os.getcwd(), ".template")

    # 目标项目目录
    target_project_dir = os.path.join(inputs['target_dir'], inputs['project_name'])

    print(f"\n正在复制模板到 {target_project_dir}...")

    try:
        # 复制模板目录到目标位置
        shutil.copytree(template_dir, target_project_dir)

        # 替换文件中的占位符
        print("\n正在替换文件中的占位符...")
        process_directory(target_project_dir, replacements)

        # 执行必要的命令
        print("\n正在执行初始化命令...")
        if execute_commands(target_project_dir):
            print("\n项目初始化完成！")
        else:
            print("\n项目初始化过程中出现错误，请检查以上输出。")

        # 收集平台配置信息（如果尚未收集）
        if not platforms:
            print("\n接下来配置平台...")
            platforms = get_platform_config()

        # 配置平台
        if platforms:
            if configure_platforms(target_project_dir, platforms):
                print("\n平台配置完成！")
            else:
                print("\n平台配置过程中出现错误，请检查以上输出。")

        # 询问是否打开项目目录，除非通过命令行指定不打开
        if not use_args or not inputs.get('no_open', False):
            open_dir = input("\n是否打开项目目录？(y/n): ").strip().lower()
            if open_dir == 'y':
                open_directory(target_project_dir)
                print(f"已打开项目目录: {target_project_dir}")
        elif use_args and not inputs.get('no_open', False):
            open_directory(target_project_dir)
            print(f"已打开项目目录: {target_project_dir}")

        print("\n感谢使用！")

    except Exception as e:
        print(f"发生错误: {e}")
        sys.exit(1)


if __name__ == "__main__":
    main()
