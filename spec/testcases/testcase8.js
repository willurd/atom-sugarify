const classNames = require('classnames');
const moment = require('moment');
require('css!./__styles__/GroupEventEditor');
const GroupEventForm = require('./GroupEventForm');
const SaveCancelButtons = require('./SaveCancelButtons');
const EventType = require('bundles/author-group-events/models/EventType');
const GroupEvent = require('bundles/author-group-events/models/GroupEvent');
const {Tester} = require('bundles/author-test/test/Tester');
const {createGroupEvent, editGroupEvent, deleteGroupEvent} = require('bundles/author-group-events/actions/GroupEventsActions');
const GroupEventPropTypes = require('bundles/author-group-events/constants/GroupEventPropTypes');
const EventDetailsMapper = require('bundles/author-group-events/models/eventDetails/EventDetailsMapper');
const CMLUtils = require('bundles/phoenix/utils/CMLUtils');
const _t = require('i18n!nls/groups');
const { DropdownButton, MenuItem } = require('react-bootstrap');
const React = require('react-with-addons');
