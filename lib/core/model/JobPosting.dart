class JobPosting {
  String jobTitle;
  String jobDescription;

  JobPosting({this.jobTitle, this.jobDescription});

  JobPosting.fromJson(Map<String, dynamic> json) {
    jobTitle = json['jobTitle'];
    jobDescription = json['jobDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jobTitle'] = this.jobTitle;
    data['jobDescription'] = this.jobDescription;
    return data;
  }
}