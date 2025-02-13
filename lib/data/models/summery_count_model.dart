import 'task_summery_data_model.dart';

class SummeryCountModel {
  String? status;
  List<SummeryData>? summeryList;

  SummeryCountModel({this.status, this.summeryList});

  SummeryCountModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      summeryList = <SummeryData>[];
      json['data'].forEach((v) {
        summeryList!.add(SummeryData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (summeryList != null) {
      data['data'] = summeryList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

