import 'package:flutter_test/flutter_test.dart';
import 'package:sdpcarelink/shared/services/mock_repositories.dart';

void main() {
  test(
    'demo repositories provide property-filtered data and local actions',
    () {
      const property = 'Green Heights Residence';
      final posts = MockPostRepository();
      final issues = MockIssueRepository();
      final projects = MockProjectRepository();
      final events = MockEventRepository();
      final profile = MockProfileRepository();

      expect(posts.getPosts().length, 10);
      expect(posts.getPosts(propertyName: property).length, 8);
      expect(issues.getIssues(propertyName: property).length, 5);
      expect(issues.getIssues(propertyName: 'SkyView Apartment').length, 1);
      expect(issues.getIssues(propertyName: 'Lake Residence').length, 1);
      expect(projects.getProjects(propertyName: property).length, 4);
      expect(projects.getProjects(propertyName: 'SkyView Apartment').length, 1);
      expect(projects.getProjects(propertyName: 'Lake Residence').length, 1);
      expect(events.getEvents(propertyName: property).length, 3);
      expect(events.getEvents(propertyName: 'SkyView Apartment').length, 1);
      expect(events.getEvents(propertyName: 'Lake Residence').length, 1);

      final post = posts.getById('post-1')!;
      final previousLikes = post.likes;
      posts.react(post.id, 'Like');
      expect(post.likes, previousLikes + 1);
      posts.addComment(post.id, 'Thanks for the update.');
      expect(post.comments.last, 'Thanks for the update.');

      final project = projects.getById('project-1')!;
      final previousSupport = project.supportCount;
      projects.vote(project.id, 'Oppose');
      expect(project.opposeCount, 20);
      projects.vote(project.id, 'Oppose');
      expect(project.opposeCount, 19);
      expect(project.supportCount, previousSupport - 1);

      final event = events.getEvents(propertyName: property).first;
      final previousParticipants = event.participantCount;
      events.rsvp(event.id, 'interested');
      expect(event.participantCount, previousParticipants);
      events.rsvp(event.id, 'interested');
      expect(event.participantCount, previousParticipants - 1);

      issues.reportIssue(
        title: 'Demo test report',
        description: 'A local prototype report.',
        category: 'Maintenance',
        location: 'Block A',
        severity: 'Low',
        propertyName: property,
      );
      expect(
        issues.getIssues(propertyName: property).first.title,
        'Demo test report',
      );
      expect(profile.issuesReported, 2);
    },
  );
}
