String formatMessageDetails(String summary, Map cvObj, List skillsList,
    List educationList, List employmentHistoryList, List projectsList) {
  final StringBuffer formattedMessage = StringBuffer();

  formattedMessage.writeln('𝗦𝘂𝗺𝗺𝗮𝗿𝘆:');
  formattedMessage.writeln(summary);
  formattedMessage.writeln();
  formattedMessage.writeln('𝗣𝗲𝗿𝘀𝗼𝗻𝗮𝗹 𝗜𝗻𝗳𝗼:');
  formattedMessage.writeln('Name: ${cvObj['personal_information']['name']}');
  String jobTitle = cvObj['personal_information']['job_title'] ?? '';
  if (jobTitle.isNotEmpty) {
    formattedMessage.writeln('Job Title: $jobTitle');
  }
  formattedMessage.writeln('Email: ${cvObj['personal_information']['email']}');
  formattedMessage.writeln('Phone: ${cvObj['personal_information']['number']}');
  formattedMessage
      .writeln('Address: ${cvObj['personal_information']['address']}');
  String linkedinProfile = cvObj['personal_information']['linkedin'] ?? '';
  if (linkedinProfile.isNotEmpty) {
    formattedMessage.writeln('Linkedin: $linkedinProfile');
  }
  String githubProfile = cvObj['personal_information']['github'] ?? '';
  if (githubProfile.isNotEmpty) {
    formattedMessage.writeln('Github: $githubProfile');
  }
  String website = cvObj['personal_information']['website'] ?? '';
  if (website.isNotEmpty) {
    formattedMessage.writeln('Website: $website');
  }
  formattedMessage.writeln();
  formattedMessage.writeln('𝗦𝗸𝗶𝗹𝗹𝘀:');
  for (Map<String, dynamic> skill in skillsList) {
    formattedMessage.writeln('• ${skill['name']}');
  }
  formattedMessage.writeln();
  formattedMessage.writeln('𝗘𝗱𝘂𝗰𝗮𝘁𝗶𝗼𝗻:');
  for (Map<String, dynamic> education in educationList) {
    formattedMessage.writeln('Degree: ${education['field_of_study']}');
    formattedMessage.writeln('Institute: ${education['institute_name']}');
    formattedMessage.writeln('City: ${education['city']}');
    formattedMessage.writeln('Country: ${education['country']}');
    formattedMessage.writeln('Start date: ${education['start_date']}');
    formattedMessage.writeln('End date: ${education['end_date']}');
    formattedMessage.writeln('Description: ${education['description']}');
    formattedMessage.writeln();
  }
  formattedMessage.writeln('𝗘𝗺𝗽𝗹𝗼𝘆𝗺𝗲𝗻𝘁 𝗛𝗶𝘀𝘁𝗼𝗿𝘆:');
  for (Map<String, dynamic> employment in employmentHistoryList) {
    formattedMessage.writeln('Position: ${employment['job_title']}');
    formattedMessage.writeln('Company: ${employment['company_name']}');
    formattedMessage.writeln('City: ${employment['city']}');
    formattedMessage.writeln('Country: ${employment['country']}');
    formattedMessage.writeln('Start date: ${employment['start_date']}');
    formattedMessage.writeln('End date: ${employment['end_date']}');
    formattedMessage.writeln('Description: ${employment['description']}');
    formattedMessage.writeln();
  }
  formattedMessage.writeln('𝗣𝗿𝗼𝗷𝗲𝗰𝘁𝘀:');
  for (Map<String, dynamic> project in projectsList) {
    formattedMessage.writeln('Project Name: ${project['project_name']}');
    formattedMessage.writeln('Description: ${project['description']}');
    formattedMessage.writeln();
  }
  formattedMessage.writeln();
  return formattedMessage.toString();
}
