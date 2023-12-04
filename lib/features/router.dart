import 'package:clarified_mobile/features/profiles/screens/profile_password.dart';
import 'package:clarified_mobile/features/subjects/screen/case_study_view.dart';
import 'package:clarified_mobile/features/subjects/screen/quiz_wizard.dart';
import 'package:clarified_mobile/features/subjects/screen/study_materials.dart';
import 'package:clarified_mobile/parents/features/community/screen/community.dart';
import 'package:clarified_mobile/parents/features/community/screen/create_post.dart';
import 'package:clarified_mobile/parents/features/community/screen/my_post.dart';
import 'package:clarified_mobile/parents/features/home/screens/p_home.dart';
import 'package:clarified_mobile/parents/features/playbook/screen/playbook_detail_view.dart';
import 'package:clarified_mobile/parents/features/playbook/screen/playbook_view.dart';
import 'package:clarified_mobile/parents/features/report/screen/p_report.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import 'package:clarified_mobile/features/feedback/screen/feedback_view.dart';
import 'package:clarified_mobile/features/home/screens/notification_page.dart';
import 'package:clarified_mobile/features/leaderboard/screens/leaderboard_screen.dart';
import 'package:clarified_mobile/features/profiles/screens/avatar_list_page.dart';
import 'package:clarified_mobile/features/profiles/screens/profile_editor.dart';
import 'package:clarified_mobile/features/survey/screens/survey_view.dart';
import 'package:clarified_mobile/features/profiles/screens/student_profile.dart';
import 'package:clarified_mobile/features/subjects/screen/subject_detail.dart';
import 'package:clarified_mobile/features/subjects/screen/complete_topic_list.dart';
import 'package:clarified_mobile/features/subjects/screen/subject_view.dart';
import 'package:clarified_mobile/features/auth/screens/login.dart';
import 'package:clarified_mobile/features/home/screens/home.dart';

class _authStateChanged with ChangeNotifier {
  User? user;

  _authStateChanged() {
    FirebaseAuth.instance.userChanges().listen((event) {
      user = event;
      notifyListeners();
    });
  }
}

GoRouter initRouter() {
  final authWatcher = _authStateChanged();

  return GoRouter(
    redirect: (ctx, state) {
      return authWatcher.user?.uid.isNotEmpty == true ? state.path : "/login";
    },
    refreshListenable: authWatcher,
    routes: [
      GoRoute(
        path: '/',
        name: "home",
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/subjects',
        name: "subject",
        builder: (context, state) => const SubjectView(),
      ),
      GoRoute(
        path: '/subject-detail/:subjectId',
        name: "subject-detail",
        builder: (context, state) => SubjectDetail(
          subjectId: state.pathParameters['subjectId'] ?? '-',
        ),
      ),
      GoRoute(
        path: '/recent-topics',
        name: "recent-topics",
        builder: (context, state) => const CompletedTopicList(),
      ),
      GoRoute(
        path: '/feedback/:subjectId/:topicId',
        name: "topic-feedback",
        builder: (context, state) => TopicFeedbackView(
          subjectId: state.pathParameters["subjectId"]!,
          topicId: state.pathParameters["topicId"]!,
          data: state.uri.queryParameters,
        ),
      ),
      GoRoute(
        path: '/leaderboard',
        name: "leaderboard",
        builder: (context, state) => const LeaderboardPage(),
      ),
      GoRoute(
        path: '/profile',
        name: "profile",
        builder: (context, state) => const StudentProfile(),
      ),
      GoRoute(
        path: '/profile/change-password',
        name: "profile-passwd",
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/profile/edit',
        name: "profile-edit",
        builder: (context, state) => const ProfileEditorPage(),
      ),
      GoRoute(
        path: '/profile/change-password',
        name: "profile-change-password",
        builder: (context, state) => const ChangePasswordPage(),
      ),
      GoRoute(
        path: '/profile/avater',
        name: "profile-avatar",
        builder: (context, state) => const ChooseAvatarPage(),
      ),
      GoRoute(
        path: '/quiz',
        name: "topic-quiz",
        builder: (context, state) => QuizWizardPage(
          subjectId: state.uri.queryParameters["subjectId"]!,
          topicId: state.uri.queryParameters["topicId"]!,
          topicName: state.uri.queryParameters["topicName"]!,
          subjectName: state.uri.queryParameters["subjectName"]!,
        ),
      ),
      GoRoute(
        path: '/case-study',
        name: 'case-study',
        builder: (context, state) => CaseStudyViewer(
          subjectId: state.uri.queryParameters["subjectId"]!,
          topicId: state.uri.queryParameters["topicId"]!,
        ),
      ),
      GoRoute(
        path: '/course-material',
        name: 'course-material',
        builder: (context, state) => StudyMaterial(
          subjectId: state.uri.queryParameters["subjectId"]!,
          topicId: state.uri.queryParameters["topicId"]!,
        ),
      ),
      GoRoute(
        path: '/profile-notification',
        name: 'profile-notification',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/survey/:surveyId',
        name: "survey-wizard",
        builder: (context, state) => SurveyWizardPage(
          surveyId: state.pathParameters['surveyId'] ?? '-',
          extraData: state.extra,
        ),
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/p_home',
        name: "parents-home",
        builder: (context, state) => const ParentsHome(),
      ),
      GoRoute(
        path: '/p_report',
        name: "parents-report",
        builder: (context, state) => const ParentsReport(),
      ),
      GoRoute(
        path: '/p_playbook',
        name: "parents-playbook",
        builder: (context, state) => PlaybookScreen(),
      ),
      GoRoute(
        path: '/p_playbook_detail',
        name: "parents-playbook-detail",
        builder: (context, state) => PlaybookDetailScreen(),
      ),
      GoRoute(
        path: '/p_community',
        name: "parents-community",
        builder: (context, state) => CommunityScreen(),
      ),
       GoRoute(
        path: '/p_my_post',
        name: "parents-my-post",
        builder: (context, state) => MyPostScreen(),
      ),
       GoRoute(
        path: '/p_create_post',
        name: "parents-create-post",
        builder: (context, state) => CreatePostScreen(),
      ),
    ],
  );
}