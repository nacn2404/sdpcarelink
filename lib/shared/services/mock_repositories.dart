import 'package:flutter/foundation.dart';

import '../../features/events/data/event_model.dart';
import '../../models/issue_model.dart';
import '../../models/post_model.dart';
import '../../models/project_model.dart';
import '../../models/user_model.dart';

const demoProperties = <String>[
  'Green Heights Residence',
  'SkyView Apartment',
  'Lake Residence',
];

class MockCommunityStore extends ChangeNotifier {
  MockCommunityStore._() {
    _seed();
  }

  static final MockCommunityStore instance = MockCommunityStore._();

  final List<PostModel> posts = [];
  final List<Issue> issues = [];
  final List<Project> projects = [];
  final List<CommunityEvent> events = [];
  final Map<String, List<(String, String)>> projectComments = {};

  void refresh() => notifyListeners();

  final UserModel resident = const UserModel(
    id: 'jane-doe',
    name: 'Jane Doe',
    email: 'jane.doe@example.com',
  );

  void _seed() {
    final now = DateTime.now();
    final community = demoProperties[0];
    final skyline = demoProperties[1];
    final lake = demoProperties[2];

    final postSeed = <(String, String, String, int, int, List<String>)>[
      (
        'Lift A maintenance scheduled tomorrow.',
        'The management team will service Lift A from 9:00 AM. Please use Lift B during the maintenance window.',
        'Aisha Rahman',
        4,
        3,
        ['Maintenance', 'Facilities'],
      ),
      (
        'Visitor parking expansion proposal is now open for voting.',
        'We have shared a proposal to add visitor bays near the north entrance. Take a look at the plans and cast your vote.',
        'Daniel Wong',
        18,
        7,
        ['Parking', 'Community'],
      ),
      (
        'Parking congestion reported at Block C.',
        'The evening queue is backing up to the main gate. Has anyone tried the south entrance after 6 PM?',
        'Mei Ling',
        12,
        9,
        ['Parking'],
      ),
      (
        'Community garden proposal will be discussed next weekend.',
        'Bring your ideas for planting beds and shared herbs to Saturday’s garden meet-up at the lawn.',
        'Ravi Kumar',
        15,
        5,
        ['Community', 'Events'],
      ),
      (
        'Street lighting replacement works begin next Monday.',
        'Contractors will replace the lights along the jogging path over two evenings. The path remains open.',
        'Sofia Tan',
        8,
        2,
        ['Maintenance', 'Security'],
      ),
      (
        'Found a set of keys near the multipurpose hall.',
        'A keyring with two keys has been handed to the concierge. Please describe the keychain to claim it.',
        'Farah Ismail',
        6,
        4,
        ['Community'],
      ),
      (
        'Weekend swimming pool hours',
        'The pool opens at 7 AM this Sunday. Please remember to sign in guests at the guardhouse.',
        'Marcus Lee',
        11,
        6,
        ['Facilities'],
      ),
      (
        'Security team completed a night patrol review.',
        'The management office is reviewing resident feedback about patrol coverage around the car park.',
        'Nadia Aziz',
        20,
        8,
        ['Security'],
      ),
      (
        'Thank you to everyone who joined the cleanup.',
        'We filled 14 bags and cleared the drain by the playground. Photos and the next cleanup date coming soon.',
        'Ethan Lim',
        24,
        11,
        ['Events', 'Community'],
      ),
      (
        'Any recommendations for a reliable bicycle repair shop?',
        'Looking for a nearby shop that can service a child’s bicycle this week. Recommendations appreciated!',
        'Priya Nair',
        5,
        10,
        ['Community'],
      ),
    ];
    for (var i = 0; i < postSeed.length; i++) {
      final seed = postSeed[i];
      final propertyName = i == 8
          ? skyline
          : i == 9
          ? lake
          : community;
      posts.add(
        PostModel(
          id: 'post-${i + 1}',
          propertyId: _propertyId(propertyName),
          propertyName: propertyName,
          authorId: 'resident-${i + 1}',
          authorName: seed.$3,
          title: seed.$1,
          body: seed.$2,
          createdAt: now.subtract(Duration(hours: (i + 1) * 3)),
          likes: seed.$4,
          comments: List.generate(
            seed.$5,
            (index) => 'Resident comment ${index + 1}',
          ),
          tags: seed.$6,
        ),
      );
    }

    final issueSeed =
        <(String, String, String, String, String, String, String, int)>[
          (
            'Broken Lift',
            'Lift A is making a loud grinding sound and stops unevenly between floors.',
            'Aisha Rahman',
            'Critical',
            'In Progress',
            'Lift A, Block A',
            'Facilities',
            1,
          ),
          (
            'Water Leakage',
            'Water is seeping through the ceiling near the corridor light.',
            'Jane Doe',
            'High',
            'Assigned',
            'Unit 12-08, Block B',
            'Plumbing',
            2,
          ),
          (
            'Streetlight Failure',
            'Two lights along the pedestrian path have been out for three nights.',
            'Mei Ling',
            'Medium',
            'Acknowledged',
            'Jogging path, north side',
            'Electrical',
            3,
          ),
          (
            'Illegal Parking',
            'A vehicle is repeatedly blocking the fire access lane overnight.',
            'Ravi Kumar',
            'High',
            'Submitted',
            'Block C loading bay',
            'Parking',
            4,
          ),
          (
            'Security Concern',
            'The side gate did not latch properly during the evening.',
            'Sofia Tan',
            'Critical',
            'Resolved',
            'South pedestrian gate',
            'Security',
            5,
          ),
          (
            'Damaged Playground Equipment',
            'One of the swing seat chains has a sharp exposed edge.',
            'Farah Ismail',
            'Medium',
            'In Progress',
            'Children’s playground',
            'Facilities',
            6,
          ),
          (
            'Garbage Collection Delay',
            'The recycling area has not been cleared since yesterday morning.',
            'Marcus Lee',
            'Low',
            'Acknowledged',
            'Recycling room, Block A',
            'Cleaning',
            7,
          ),
        ];
    const statuses = [
      'Submitted',
      'Acknowledged',
      'Assigned',
      'In Progress',
      'Resolved',
    ];
    for (var i = 0; i < issueSeed.length; i++) {
      final seed = issueSeed[i];
      final issueProperty = i == 5
          ? skyline
          : i == 6
          ? lake
          : community;
      final reportDate = now.subtract(Duration(days: (i + 1) * 2));
      final statusIndex = statuses.indexOf(seed.$5);
      issues.add(
        Issue(
          id: 'issue-${i + 1}',
          propertyId: _propertyId(issueProperty),
          propertyName: issueProperty,
          title: seed.$1,
          description: seed.$2,
          reportedBy: seed.$3,
          severity: seed.$4,
          status: seed.$5,
          location: seed.$6,
          category: seed.$7,
          createdAt: reportDate,
          updatedAt: reportDate.add(Duration(hours: statusIndex * 10)),
          managementResponse: seed.$5 == 'Resolved'
              ? 'The side gate latch has been repaired and tested.'
              : '',
          progressTimeline: List.generate(
            statusIndex + 1,
            (step) => IssueTimelineEntry(
              status: statuses[step],
              date: reportDate.add(Duration(hours: step * 10)),
              note: step == statusIndex
                  ? _statusNote(statuses[step])
                  : 'Status updated by the management team.',
            ),
          ),
        ),
      );
    }

    final projectSeed =
        <
          (
            String,
            String,
            String,
            List<String>,
            List<String>,
            String,
            int,
            int,
            int,
          )
        >[
          (
            'Visitor Parking Expansion',
            'Create additional marked visitor bays near the north entrance.',
            'New parking capacity can reduce street congestion and make guest access easier.',
            [
              'More visitor capacity',
              'Clearer traffic flow',
              'Improved guest access',
            ],
            ['Reduced green verge', 'Construction disruption'],
            'Planning and resident consultation: 3 months',
            128,
            19,
            23,
          ),
          (
            'Community Garden',
            'Convert the unused lawn corner into a shared resident garden.',
            'A shared garden can encourage neighbour connections and provide a green space.',
            [
              'More greenery',
              'Shared resident activity',
              'Herbs for residents',
            ],
            ['Ongoing upkeep', 'Water use'],
            'Design and pilot: 8 weeks',
            94,
            12,
            16,
          ),
          (
            'Children’s Playground Upgrade',
            'Replace worn play equipment and add shaded seating.',
            'Safer equipment and shade will make the playground comfortable for more families.',
            ['Safer equipment', 'Shade for families', 'Inclusive play options'],
            ['Temporary playground closure', 'Higher maintenance'],
            'Procurement and works: 4 months',
            112,
            17,
            9,
          ),
          (
            'Security CCTV Expansion',
            'Extend camera coverage to the car park and pedestrian entrances.',
            'Better coverage can support incident follow-up and strengthen resident confidence.',
            [
              'Improved area coverage',
              'Faster incident reviews',
              'Safer entrances',
            ],
            ['Privacy considerations', 'Ongoing system costs'],
            'Review and installation: 12 weeks',
            156,
            21,
            14,
          ),
          (
            'Covered Walkway Construction',
            'Add weather protection between the main lobby and community hall.',
            'A covered walkway improves comfort and accessibility during wet weather.',
            [
              'Weather protection',
              'Better accessibility',
              'Safer evening route',
            ],
            ['Construction access changes', 'Upfront cost'],
            'Design review and works: 5 months',
            78,
            25,
            32,
          ),
          (
            'Multi-Purpose Hall Renovation',
            'Refresh the hall flooring, lighting, and accessible entrance.',
            'A more flexible hall can host meetings, classes, and community events.',
            [
              'More useful community space',
              'Improved lighting',
              'Accessible entrance',
            ],
            ['Temporary hall closure', 'Renovation noise'],
            'Works estimated: 10 weeks',
            103,
            14,
            18,
          ),
        ];
    for (var i = 0; i < projectSeed.length; i++) {
      final seed = projectSeed[i];
          final projectProperty = i == 4
              ? skyline
              : i == 5
              ? lake
              : community;
          projects.add(
            Project(
              id: 'project-${i + 1}',
              propertyId: _propertyId(projectProperty),
              propertyName: projectProperty,
          title: seed.$1,
          description: seed.$2,
          potentialImpacts: seed.$3,
          mitigationMeasures: 'Resident consultation, phased works, and regular progress updates.',
          benefits: seed.$4,
          risks: seed.$5,
          estimatedTimeline: seed.$6,
          createdBy: 'Management Committee',
          status: 'Open for feedback',
          createdAt: now.subtract(Duration(days: i + 2)),
          supportCount: seed.$7,
          opposeCount: seed.$8,
          moreInfoCount: seed.$9,
        ),
      );
    }
    projects.first.myVote = 'Support';

    final eventSeed = <(String, String, String, String, int)>[
      (
        'Annual General Meeting',
        'Review the annual report, budget, and community priorities.',
        'Multipurpose Hall',
        'Meeting',
        86,
      ),
      (
        'Community Cleanup Day',
        'Join neighbours to refresh shared paths and garden beds.',
        'Main lawn and north path',
        'Community',
        43,
      ),
      (
        'Deepavali Celebration',
        'An evening of food, music, and activities for all residents.',
        'Community plaza',
        'Festival',
        121,
      ),
      (
        'Resident Townhall',
        'Share questions and hear updates from the management team.',
        'Multipurpose Hall',
        'Meeting',
        57,
      ),
      (
        'Family Sports Day',
        'A friendly morning of games and activities for all ages.',
        'Sports court',
        'Community',
        74,
      ),
    ];
    for (var i = 0; i < eventSeed.length; i++) {
      final seed = eventSeed[i];
      final eventProperty = i == 3
          ? skyline
          : i == 4
          ? lake
          : community;
      final eventDate = DateTime(
        now.year,
        now.month,
        now.day + (i + 2) * 4,
        9 + i,
        0,
      );
      events.add(
        CommunityEvent(
          id: 'event-${i + 1}',
          propertyId: _propertyId(eventProperty),
          propertyName: eventProperty,
          title: seed.$1,
          description: seed.$2,
          location: seed.$3,
          type: seed.$4,
          startsAt: eventDate,
          participantCount: seed.$5,
        ),
      );
    }
    events.first.myRsvp = 'going';
  }

  static String _propertyId(String name) =>
      name.toLowerCase().replaceAll(RegExp(r'[^a-z0-9]+'), '-');

  static String _statusNote(String status) => switch (status) {
    'Submitted' => 'Report received by the management team.',
    'Acknowledged' => 'Management has reviewed the report.',
    'Assigned' => 'A maintenance officer has been assigned.',
    'In Progress' => 'Work is currently underway.',
    'Resolved' => 'The reported issue has been resolved.',
    _ => '',
  };
}

class MockPostRepository {
  MockPostRepository({MockCommunityStore? store})
    : _store = store ?? MockCommunityStore.instance;

  final MockCommunityStore _store;
  Listenable get changes => _store;

  List<PostModel> getPosts({String? propertyName}) =>
      _store.posts
          .where(
            (post) => propertyName == null || post.propertyName == propertyName,
          )
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  List<PostModel> trendingPosts({String? propertyName}) {
    final posts = getPosts(propertyName: propertyName)
      ..sort(
        (a, b) =>
            (b.likes + b.commentCount).compareTo(a.likes + a.commentCount),
      );
    return posts.take(3).toList();
  }

  PostModel? getById(String id) {
    for (final post in _store.posts) {
      if (post.id == id) return post;
    }
    return null;
  }

  void createPost(
    String title,
    String body, {
    String propertyName = 'Green Heights Residence',
    List<String> tags = const [],
  }) {
    final now = DateTime.now();
    _store.posts.insert(
      0,
      PostModel(
        id: 'post-${now.microsecondsSinceEpoch}',
        propertyId: MockCommunityStore._propertyId(propertyName),
        propertyName: propertyName,
        authorId: _store.resident.id,
        authorName: _store.resident.name,
        title: title.trim(),
        body: body.trim(),
        createdAt: now,
        tags: tags,
      ),
    );
    _store.refresh();
  }

  void react(String postId, String reaction) {
    final post = getById(postId);
    if (post == null) return;
    final oldReaction = post.myReaction;
    if (oldReaction == reaction) {
      post.reactionCounts[reaction] = (post.reactionCounts[reaction] ?? 1) - 1;
      post.myReaction = null;
      if (reaction == 'Like') post.likes--;
    } else {
      if (oldReaction != null) {
        post.reactionCounts[oldReaction] =
            (post.reactionCounts[oldReaction] ?? 1) - 1;
        if (oldReaction == 'Like') post.likes--;
      }
      post.reactionCounts[reaction] = (post.reactionCounts[reaction] ?? 0) + 1;
      post.myReaction = reaction;
      if (reaction == 'Like') post.likes++;
    }
    _store.refresh();
  }

  void addComment(String postId, String comment) {
    final post = getById(postId);
    if (post == null || comment.trim().isEmpty) return;
    post.comments.add(comment.trim());
    _store.refresh();
  }
}

class MockIssueRepository {
  MockIssueRepository({MockCommunityStore? store})
    : _store = store ?? MockCommunityStore.instance;

  final MockCommunityStore _store;
  Listenable get changes => _store;

  List<Issue> getIssues({String? propertyName}) =>
      _store.issues
          .where(
            (issue) =>
                propertyName == null || issue.propertyName == propertyName,
          )
          .toList()
        ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

  void reportIssue({
    required String title,
    required String description,
    required String category,
    required String location,
    required String severity,
    String propertyName = 'Green Heights Residence',
  }) {
    final now = DateTime.now();
    _store.issues.insert(
      0,
      Issue(
        id: 'issue-${now.microsecondsSinceEpoch}',
        propertyId: MockCommunityStore._propertyId(propertyName),
        propertyName: propertyName,
        title: title.trim(),
        description: description.trim(),
        category: category,
        location: location,
        status: 'Submitted',
        reportedBy: _store.resident.name,
        severity: severity,
        createdAt: now,
        updatedAt: now,
        progressTimeline: [
          IssueTimelineEntry(
            status: 'Submitted',
            date: now,
            note: 'Report received by the management team.',
          ),
        ],
      ),
    );
    _store.refresh();
  }
}

class MockProjectRepository {
  MockProjectRepository({MockCommunityStore? store})
    : _store = store ?? MockCommunityStore.instance;

  final MockCommunityStore _store;
  Listenable get changes => _store;

  List<Project> getProjects({String? propertyName}) => _store.projects
      .where(
        (project) =>
            propertyName == null || project.propertyName == propertyName,
      )
      .toList();

  Project? getById(String id) {
    for (final project in _store.projects) {
      if (project.id == id) return project;
    }
    return null;
  }

  List<(String, String)> getComments(String projectId) =>
      List.unmodifiable(_store.projectComments[projectId] ?? const []);

  void addComment(String projectId, String comment) {
    final text = comment.trim();
    if (text.isEmpty) return;
    _store.projectComments.putIfAbsent(projectId, () => []).add((
      _store.resident.name,
      text,
    ));
    _store.refresh();
  }

  void vote(String projectId, String choice) {
    final project = getById(projectId);
    if (project == null) return;
    switch (project.myVote) {
      case 'Support':
        project.supportCount--;
        break;
      case 'Oppose':
        project.opposeCount--;
        break;
      case 'Request More Information':
        project.moreInfoCount--;
        break;
    }
    if (project.myVote == choice) {
      project.myVote = null;
    } else {
      project.myVote = choice;
      switch (choice) {
        case 'Support':
          project.supportCount++;
          break;
        case 'Oppose':
          project.opposeCount++;
          break;
        case 'Request More Information':
          project.moreInfoCount++;
          break;
      }
    }
    _store.refresh();
  }
}

class MockEventRepository {
  MockEventRepository({MockCommunityStore? store})
    : _store = store ?? MockCommunityStore.instance;

  final MockCommunityStore _store;
  Listenable get changes => _store;

  List<CommunityEvent> getEvents({String? propertyName}) =>
      _store.events
          .where(
            (event) =>
                propertyName == null || event.propertyName == propertyName,
          )
          .toList()
        ..sort((a, b) => a.startsAt.compareTo(b.startsAt));

  void rsvp(String eventId, String response) {
    CommunityEvent? event;
    for (final candidate in _store.events) {
      if (candidate.id == eventId) {
        event = candidate;
        break;
      }
    }
    if (event == null) return;
    final oldRsvp = event.myRsvp;
    final previouslyCounted = oldRsvp == 'going' || oldRsvp == 'interested';
    final nowCounted = response == 'going' || response == 'interested';
    if (previouslyCounted != nowCounted) {
      event.participantCount += nowCounted ? 1 : -1;
    }
    event.myRsvp = oldRsvp == response ? null : response;
    if (oldRsvp == response && nowCounted) event.participantCount--;
    _store.refresh();
  }
}

class MockProfileRepository {
  MockProfileRepository({MockCommunityStore? store})
    : _store = store ?? MockCommunityStore.instance;

  final MockCommunityStore _store;
  Listenable get changes => _store;

  UserModel get resident => _store.resident;
  int get issuesReported =>
      _store.issues.where((issue) => issue.reportedBy == resident.name).length;
  int get projectsVoted =>
      _store.projects.where((project) => project.myVote != null).length;
  int get eventsJoined =>
      _store.events.where((event) => event.myRsvp == 'going').length;

  List<String> get recentActivities {
    final activities = <(DateTime, String)>[];
    for (final issue in _store.issues.where(
      (i) => i.reportedBy == resident.name,
    )) {
      activities.add((issue.createdAt, 'Reported ${issue.title}'));
    }
    for (final project in _store.projects.where((p) => p.myVote != null)) {
      activities.add((
        project.createdAt,
        'Voted ${project.myVote} on ${project.title}',
      ));
    }
    for (final event in _store.events.where((e) => e.myRsvp != null)) {
      activities.add((
        event.startsAt,
        'Responded ${event.myRsvp} to ${event.title}',
      ));
    }
    activities.sort((a, b) => b.$1.compareTo(a.$1));
    return activities.take(5).map((entry) => entry.$2).toList();
  }
}
