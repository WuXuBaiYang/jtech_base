import 'package:jtech_base/common/api/request.dart';
import 'package:example/api/api.dart';

/*
* 范例接口
* 接口推荐按业务模块划分成多个文件，以便于维护
* 例如：用户模块的接口可以放在user.dart文件中、订单模块的接口可以放在order.dart文件中
* @author wuxubaiyang
* @Time 2024/10/23 10:12
*/
mixin ExampleAPI on CustomAPI {
  // 基础请求(如响应值中的data恰好为基础类型，则可以直接指定泛型)
  Future<bool> reqBool() => httpGet<bool>('/example/base');

  // 结构体post请求，并解析结构化对象
  Future<ExampleModel> reqModel() async {
    final data = await httpPost('/example/model',
        request: RequestModel.body(
          data: {
            /// 此处可以填写结构体参数（json结构体，非form）
            'key': 'value',
            'key1': 'value1',
          },
          // 也可以扩展query或header参数
          parameters: {},
          headers: {},
        ));
    return ExampleModel.from(data);
  }

  // 结构体post请求，并解析返回的集合结构化对象
  Future<List<ExampleModel>> reqModelList() async {
    final data = await httpPost('/example/model/list',
        request: RequestModel.body(
          data: {
            /// 此处可以填写结构体参数（json结构体，非form）
            'key': 'value',
            'key1': 'value1',
          },
          // 也可以扩展query或header参数
          parameters: {},
          headers: {},
        ));
    return data.map<ExampleModel>(ExampleModel.from).toList();
  }

  // 附件上传请求
  Future<ExampleModel> reqUpload(String filePath) async {
    final data = await httpPost(
      '/example/upload',

      /// RequestModel.form代表使用form表单发起请求，其中的data会被格式化为表单形式
      /// addFileSync方法用于添加文件，第一个参数为文件key，第二个参数为文件路径
      /// RequestModel采用builder形式构建，支持链式调用
      request: RequestModel.form().addFileSync('file', filePath),
    );
    return ExampleModel.from(data);
  }
}

/*
* 范例模型
* @author wuxubaiyang
* @Time 2024/10/23 10:15
*/
class ExampleModel {
  ExampleModel.from(obj);
}
