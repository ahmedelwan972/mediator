class GetCommentModel{
  String? comment;
  String? commentId;
  String? senderName;
  GetCommentModel.fromJson(Map<String,dynamic>json){
    comment = json['comment'];
    commentId = json['commentId'];
    senderName = json['senderName'];
  }

}


class GetReplayModel{
  String? replay;
  String? replayId;
  String? senderName;
  GetReplayModel.fromJson(Map<String,dynamic>json){
    replay = json['replay'];
    replayId = json['replayId'];
    senderName = json['senderName'];
  }

}