part of 'moodle.dart';

typedef GroupedMoodleEvents = Map<String, List<MoodleEvent>>;

/// Status of Moodle authentication.
enum MoodleAuthStatus { ignore, incomplete, fail, success }

/// Moodle events sorting type.
enum MoodleEventGroupingType { byTime, byCourse }

/// Moodle storage keys.
class MoodleStorageKeys {
  static const wstoken = 'moodle_wstoken';
  static const privatetoken = 'moodle_privatetoken';
  static const siteInfo = 'moodle_site_info';
  static const courses = 'moodle_courses';
  static const events = 'moodle_events';
}

/// Moodle function names.
class MoodleFunctions {
  static const getSiteInfo = 'core_webservice_get_site_info';
  static const getEnrolledCourses = 'core_enrol_get_users_courses';
  static const callExternal = 'tool_mobile_call_external_functions';
  static const getCalendarEvents = 'core_calendar_get_calendar_events';
}

/// Types of Moodle events.
class MoodleEventTypes {
  static const due = 'due';
  static const user = 'user';
  static const custom = 'custom';
}

/// Subrequest in a moodle function request.
/// However, in most cases, there is no need to use subrequests.
class MoodleFunctionSubrequest {
  MoodleFunctionSubrequest(
    this.functionName, {
    this.params,
    this.filter = true,
    this.fileUrl = true,
  });

  final String functionName;
  final Map<String, dynamic>? params;
  final bool filter;
  final bool fileUrl;

  /// Convert to string given the subrequest index.
  Map<String, String> bodyParamsWithIndex(int index) {
    return {
      'requests[$index][function]': functionName,
      'requests[$index][arguments]': jsonEncode(params ?? {}),
      'requests[$index][settingfilter]': filter ? "1" : "0",
      'requests[$index][settingfileurl]': fileUrl ? "1" : "0"
    };
  }
}

/// Moodle function call reponse wrapper.
class MoodleFunctionResponse {
  MoodleFunctionResponse(this.response) : data = response.data;

  /// Raw Dio response.
  final Response response;

  /// Data shortcut.
  final dynamic data;

  /// If the Moodle function has failed.
  bool get fail {
    bool errStatus = (response.statusCode ?? 500) != 200;
    bool exceptionExists =
        data is Map && data?['exception'] == 'moodle_exception';
    return errStatus && exceptionExists;
  }

  /// Get error code if any.
  String? get errCode => data?['errorcode'];

  /// Get error message if any.
  String? get errMessage => data?['message'];

  /// Get subresponse data at specific index.
  T? subResponseData<T>(int index, {bool requireJSONDecode = true}) {
    if (data is! Map<String, dynamic>) return null;
    final responses = data['responses'];
    if (responses is! List) return null;
    var subData = responses[index]['data'];
    if (requireJSONDecode) {
      try {
        subData = jsonDecode(subData);
      } catch (e) {
        return null;
      }
    }
    return subData as T;
  }
}

/// Shortcuts for Moodle event.
extension MoodleEventExtension on MoodleEvent {
  /// Course for Moodle event.
  MoodleCourse? get course => Moodle.courseForEvent(this);

  /// Remaining seconds for Moodle event.
  num get remainingTime => timestart - DateTime.now().secondEpoch;
}

/// Shortcuts for Moodle course.
extension MoodleCourseExtension on MoodleCourse {
  /// Standard ABCDXXXX course code.
  String get courseCode => fullname.split(' ').first;
}