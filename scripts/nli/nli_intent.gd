extends RefCounted
class_name NLIIntent

## Typed intent envelope shared by the NLI pipeline.
enum Kind { QUESTION, COMPANION_COMMAND, CANCEL }

var kind: Kind = Kind.QUESTION
var request_id: String = ""
var utterance: String = ""
var topic: StringName = &""
var command: StringName = &""
var companion_id: String = ""
var npc_id: StringName = &""
