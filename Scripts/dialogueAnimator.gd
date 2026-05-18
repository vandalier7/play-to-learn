extends CustomAnimator

class_name DialogueAnimator

func setText(txt: String, hidden: bool = true) -> void:
	assert(is_instance_of(parent, RichTextLabel))
	var label: RichTextLabel = parent
	if hidden:
		label.visible_characters = 0
	else:
		label.visible_characters = -1
		
	label.text = txt

func typewrite(interval: float) -> void:
	assert(is_instance_of(parent, RichTextLabel))
	var label: RichTextLabel = parent
	label.visible_characters = 0
	for i in label.get_total_character_count():
		label.visible_characters += 1
		var ch: String = label.text[i]
		if ch == "." or ch == "!" or ch == "?":
			await get_tree().create_timer(interval * 10).timeout
		elif ch == ",":
			await get_tree().create_timer(interval * 5).timeout
		else:
			await get_tree().create_timer(interval).timeout
