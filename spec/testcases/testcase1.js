define(function(require) {

  one

  require('js/app/origamiSingleton.v0-0-1');

  var _ = require('js/vendor/underscore.v1-6');
  var assert = require('js/lib/assert');
  var courseMaterialsPromise = require('pages/open-course/common/singletons/courseMaterials');
  var courseProgressPromise = require('pages/open-course/common/singletons/courseProgress');
  var coursePromise = require('pages/open-course/common/singletons/course');
  var exceptions = require('bundles/phoenix/lib/exceptions');
  var getAssignmentTypeConfig = require('pages/open-course/peerReview/assignmentTypes/getAssignmentTypeConfig');
  var itemEntry = require('pages/open-course/item/entry');
  var ItemMetadataPromise = require('memoize!pages/open-course/common/promises/itemMetadata');
  var origami = require('js/app/origamiSingleton.v0-0-1');

  require('pages/open-course/item/entry');
  require('memoize!pages/open-course/common/promises/itemMetadata');


  var path = require('js/lib/path');
  var peerReviewApi = require('pages/open-course/peerReview/data/api');
  var peerReviewAssignmentModel = require('pages/open-course/peerReview/assignmentTypes/base/promises/assignment');
  var peerReviewSubmissionModel = require('pages/open-course/peerReview/assignmentTypes/base/promises/submission');
  var Q = require('js/vendor/q.v1-0-1');
  var Question = require('pages/open-course/discourse/models/question');
  var questionPromise = require('pages/open-course/discourse/promises/question');
  var submissionsPromise = require('pages/open-course/peerReview/promises/submissionSummaries');

  two

  var test = require('something');

  three

});
