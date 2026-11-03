class_name BtvNliParserTest
extends GdUnitTestSuite

const Parser = preload("res://scripts/nli/nli_command_parser.gd")


func test_exact_scout_command_is_parsed() -> void:
	var result: Dictionary = Parser.parse("scout ahead", "gdunit-scout-001", "companion-test")
	assert_bool(result.get("ok", false)).is_true()
	assert_that(result.get("intent", {}).get("command")).is_equal(&"scout")


func test_unknown_command_is_not_guessed() -> void:
	var result: Dictionary = Parser.parse("do something surprising", "gdunit-unknown-001")
	assert_bool(result.get("ok", false)).is_false()


func test_unsupported_question_requires_clarification() -> void:
	var result: Dictionary = Parser.parse("what happened at Ridgeview?", "gdunit-question-001")
	assert_that(result.get("code")).is_equal("clarification_required")
