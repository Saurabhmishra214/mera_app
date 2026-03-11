class UserInformation {
  static String User_uId = '';
  static String teacherverifycode = '';
  static String parentverifycode = '';
  static String email = '';
  static var classroom;
  static var classid = '';
  static var grade = 0;
  static var grade_average = 0.0;
  static String first_name = '';
  static String last_name = '';
  static String? Token;
  static var fees = '';
  static var phone = '';
  static var date_start;
  static var date_left;
  static var Subjects = [];
  static var parentphone = '';
  static var urlAvatr = '';
  static var clasname = '';
  static var fullfees = '';
  static var fullname = '';
  static var about;
  static bool uParent = false;

  // Laravel API token
  static String? apiToken;
  static String? role; // 'teacher', 'student', 'admin'

  static void clear() {
    User_uId = '';
    email = '';
    first_name = '';
    last_name = '';
    Token = null;
    apiToken = null;
    role = null;
    urlAvatr = '';
    fullname = '';
    uParent = false;
  }
}