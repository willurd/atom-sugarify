/**
 * asdf
 */

define([
  'js/vendor/backbone.v1-1-2',
  'js/vendor/jquery.v2-1',
  'js/vendor/underscore.v1-6',
  'js/lib/path',
  'pages/open-course/peerReview/views/review.html',
  'pages/open-course/peerReview/feedback/views/main',
  'pages/open-course/peerReview/likes/models/likes',
  'pages/open-course/peerReview/likes/views/likes',
  'pages/open-course/peerReview/likes/views/smallLikeBox.html',
  'pages/open-course/peerReview/likes/views/largeLikeBox.html',
  'pages/open-course/peerReview/assignmentTypes/getAssignmentTypeConfig',
  'bundles/phoenix/lib/view',
  'pages/open-course/peerReview/feedback/models/feedbackCollection',

  // Load!
  'css!more',
  'things'
], function(
  Backbone,
  $,
  _,
  path,
  template,
  MainFeedbackView,
  LikeModel,
  LikeView,
  smallLikeBoxTemplate,
  largeLikeBoxTemplate,
  getAssignmentTypeConfig,
  PhoenixView,
  FeedbackCollection
) {

  var MyView = Backbone.View.extend({
  });

  return MyView;

});
