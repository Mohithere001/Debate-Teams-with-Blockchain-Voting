// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LearnToEarn {
    struct Course {
        string title;
        string description;
        uint256 reward;
        address instructor;
    }

    struct Learner {
        address learnerAddress;
        uint256 completedCourses;
        uint256 earnings;
    }

    address public admin;
    Course[] public courses;
    mapping(address => Learner) public learners;
    mapping(address => mapping(uint256 => bool)) public courseCompletion;

    event CourseAdded(uint256 courseId, string title, address instructor);
    event CourseCompleted(address learner, uint256 courseId, uint256 reward);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can perform this action.");
        _;
    }

    modifier onlyInstructor(uint256 courseId) {
        require(msg.sender == courses[courseId].instructor, "Only the instructor can perform this action.");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function addCourse(string memory _title, string memory _description, uint256 _reward) public {
        courses.push(Course({
            title: _title,
            description: _description,
            reward: _reward,
            instructor: msg.sender
        }));
        emit CourseAdded(courses.length - 1, _title, msg.sender);
    }

    function completeCourse(uint256 courseId) public {
        require(courseId < courses.length, "Invalid course ID.");
        require(!courseCompletion[msg.sender][courseId], "Course already completed.");

        Course memory course = courses[courseId];

        learners[msg.sender].learnerAddress = msg.sender;
        learners[msg.sender].completedCourses++;
        learners[msg.sender].earnings += course.reward;

        courseCompletion[msg.sender][courseId] = true;

        emit CourseCompleted(msg.sender, courseId, course.reward);
    }

    function getCourses() public view returns (Course[] memory) {
        return courses;
    }

    function getLearner(address _learner) public view returns (Learner memory) {
        return learners[_learner];
    }
}
