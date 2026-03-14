# SchoolMate-App
![student mockup_112716](https://github.com/Yassin522/SchoolMate-App/assets/88105077/285ac72b-da7c-43c2-b980-3dbef4c23b75)

![teacher mockup_014955](https://github.com/Yassin522/SchoolMate-App/assets/88105077/0b2c3ae4-efe6-4741-995b-afb67101d482)




Yeh lo — poora folder structure aur har file ki definition! 👇

lib/
│
├── main.dart                          🚀 App start hota hai yahan se
│
├── routes/
│   └── app_pages.dart                 🗺️ Saari screens ke routes (kaunsi screen kahan jaaye)
│
│
├── public/                            🌐 SABKE LIYE — Login/Splash (Common)
│   ├── splash/
│   │   ├── splash_screen.dart         💫 App khulne par pehli screen
│   │   └── splash_controller.dart     ⚙️ Splash ka logic
│   ├── login/
│   │   ├── login_screen.dart          🔐 Login screen (Student/Teacher/Parent)
│   │   ├── verify_code_parent.dart    📱 Parent ka OTP verify
│   │   ├── verify_code_teacher.dart   📱 Teacher ka OTP verify
│   │   ├── dividerwithtext.dart       ── Login screen ka divider widget
│   │   └── dividerforparent.dart      ── Parent login ka divider
│   ├── auth/
│   │   └── auth_methods.dart          🔑 Firebase login/logout logic
│   ├── widgets/                       🧩 Common reusable buttons, forms
│   │   ├── custom_button.dart
│   │   ├── custom_formfield.dart
│   │   ├── custom_dialog.dart
│   │   └── rounded_button.dart
│   └── utils/
│       ├── constant.dart              🎨 Colors, sizes
│       ├── font_families.dart         ✍️ Font names
│       └── util.dart                  🔧 Helper functions
│
│
├── admin/                             👨‍💼 ADMIN PANEL
│   ├── view/
│   │   └── admin_home.dart            🏠 Admin home screen
│   ├── controllers/
│   │   └── admin_home.dart            ⚙️ Admin ka logic
│   ├── models/
│   │   └── admin.dart                 📦 Admin data model
│   └── resources/
│       └── api.dart                   🌐 Admin ke API calls
│
│
├── parent/                            👨‍👩‍👦 PARENT PANEL
│   └── view/
│       └── home.dart                  🏠 Parent home screen
│
│
├── student/                           🎓 STUDENT PANEL (Sabse bada)
│   │
│   ├── view/                          📱 Student ki saari screens
│   │   ├── Home/
│   │   │   ├── home.dart              🏠 Student home screen
│   │   │   ├── home_body.dart         📋 Home ka main content
│   │   │   ├── home_appbar.dart       🔝 Home ka top bar
│   │   │   ├── side_menu.dart         📂 Side drawer menu
│   │   │   └── subjectCart.dart       📚 Subject card widget
│   │   ├── Profile/
│   │   │   └── stprofile.dart         👤 Student profile screen
│   │   ├── Subjects/
│   │   │   ├── SubjectsScreen.dart    📚 Subjects list screen
│   │   │   ├── LessonsScreen.dart     📖 Lessons screen
│   │   │   └── MarksScreen.dart       📊 Marks/Results screen
│   │   ├── TasksScreen/
│   │   │   ├── TasksPage.dart         📝 Homework/Tasks list
│   │   │   └── TasksCard.dart         🃏 Task card widget
│   │   ├── Announcements/
│   │   │   ├── AnnouncementsPage.dart 📢 Notices screen
│   │   │   └── announcementsCard.dart 🃏 Notice card widget
│   │   ├── Chat/
│   │   │   ├── chats_page.dart        💬 Chat list screen
│   │   │   └── chat_page.dart         💬 Single chat screen
│   │   ├── Adjuncts/
│   │   │   ├── adjuncts.dart          📎 Extra materials screen
│   │   │   ├── Videos.dart            🎥 Video lectures
│   │   │   ├── refrences.dart         📄 PDF references
│   │   │   └── Quizz.dart             ❓ Quiz screen
│   │   └── TeacherEmails/
│   │       └── Teacherspage.dart      📧 Teacher ko email karo
│   │
│   ├── controllers/                   ⚙️ Student ka business logic
│   │   ├── home_controller.dart       🏠 Home logic
│   │   ├── TasksController.dart       📝 Tasks logic
│   │   ├── AnnouncementsController.dart 📢 Notices logic
│   │   ├── marksController.dart       📊 Marks logic
│   │   ├── lessonsController.dart     📖 Lessons logic
│   │   └── stprofile_controller.dart  👤 Profile logic
│   │
│   └── models/                        📦 Student ka data structure
│       ├── user.dart                  👤 Student user model
│       ├── task/task_model.dart       📝 Task model
│       ├── Subjects/SubjectsModel.dart 📚 Subject model
│       └── Announcements/             📢 Notice model
│
│
└── teacher/                           👨‍🏫 TEACHER PANEL (Sabse zyada features)
    │
    ├── view/                          📱 Teacher ki saari screens
    │   ├── Home/
    │   │   ├── teacher_home.dart      🏠 Teacher home screen
    │   │   └── HomeBody.dart          📋 Home ka content
    │   ├── TProfile/
    │   │   └── TProfileScreen.dart    👤 Teacher profile screen
    │   ├── SProfile/
    │   │   └── SProfileScreen.dart    👤 Student ka profile (teacher dekhe)
    │   ├── TSubject/
    │   │   ├── Subjects/SubjectScreen.dart  📚 Subjects screen
    │   │   ├── TlessonScreen.dart     📖 Lessons manage karo
    │   │   ├── TMarkScreen.dart       📊 Marks dalo
    │   │   └── TSubjectsInfo.dart     ℹ️ Subject details
    │   ├── TaskScreen/
    │   │   └── task_screen.dart       📝 Task create karo
    │   ├── tasks/
    │   │   ├── TeacherTasksPage.dart  📋 Tasks list
    │   │   ├── TeacherTasksCard.dart  🃏 Task card
    │   │   └── studentsOfTask.dart    👥 Kis student ne task kiya
    │   ├── TAnnouncements/
    │   │   └── TAnnouncementsScreen.dart 📢 Notice bhejo
    │   ├── Adjuncts/
    │   │   ├── TeacherAdjuncts.dart   📎 Materials upload
    │   │   ├── TVideos.dart           🎥 Video upload
    │   │   ├── TeacherPdfRefrences.dart 📄 PDF upload
    │   │   └── TQuizz.dart            ❓ Quiz banao
    │   └── Chat/
    │       ├── chats_page.dart        💬 Chat list
    │       └── chat_page.dart         💬 Single chat
    │
    ├── controllers/                   ⚙️ Teacher ka business logic
    └── models/                        📦 Teacher ka data structure

📊 Summary — Kaun Kaun Si Screens Hain?
UserScreens👨‍💼 AdminHome, User management👨‍👩‍👦 ParentHome, Child ka status dekho🎓 StudentHome, Subjects, Marks, Tasks, Notices, Chat, Quiz, Videos👨‍🏫 TeacherHome, Subjects, Marks dalo, Tasks do, Notice bhejo, Chat, Quiz banao