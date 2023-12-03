import 'package:flutter/material.dart';

typedef TAnswer = ({dynamic id, String label});

class SCQAnsewrComponent extends StatelessWidget {
  final List<TAnswer> answers;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;

  const SCQAnsewrComponent({
    super.key,
    required this.answers,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: answers.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        final ans = answers[index];

        return QCheckButton(
          onSelected: () => onAnswerSelected(ans.id),
          label: ans.label,
          isSelected: ans.id == selectedAnswer,
        );
      },
    );
  }
}

class QCheckButton extends StatelessWidget {
  const QCheckButton({
    super.key,
    required this.onSelected,
    required this.label,
    required this.isSelected,
    this.selectedIcon = Icons.check_circle,
    this.icon = Icons.circle_outlined,
  });

  final IconData icon;
  final IconData selectedIcon;
  final Function() onSelected;
  final String label;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: onSelected,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        padding: const EdgeInsets.all(16),
        decoration: ShapeDecoration(
          color: isSelected ? const Color(0xFFEFF4FF) : const Color(0xFFFCFCFD),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isSelected
                  ? const Color(0xFF83ADFF)
                  : const Color(0xFFEAECF0),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF2970FF), // Colors.grey,
              )
            else
              const Icon(
                Icons.circle_outlined,
                color: Colors.grey,
              ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                label,
                textAlign: TextAlign.left,
                softWrap: true,
                style: const TextStyle(
                  color: Color(0xFF344054),
                  fontSize: 16,
                  fontFamily: 'Lexend',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MCQAnsewrComponent extends StatelessWidget {
  final List<TAnswer> answers;
  final Set<String>? selectedAnswers;
  final Function(Set<String>) onAnswerSelected;

  const MCQAnsewrComponent({
    super.key,
    required this.answers,
    required this.selectedAnswers,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: answers.length,
      separatorBuilder: (BuildContext context, int index) {
        return const SizedBox(
          height: 10,
        );
      },
      itemBuilder: (BuildContext context, int index) {
        final ans = answers[index];

        return QCheckButton(
          selectedIcon: Icons.check_box_rounded,
          icon: Icons.square,
          label: ans.label,
          isSelected: selectedAnswers?.contains(ans.id) == true,
          onSelected: () {
            if (selectedAnswers?.contains(ans.id) == true) {
              selectedAnswers!.remove(ans.id);
              onAnswerSelected(selectedAnswers!);
              return;
            }

            onAnswerSelected(<String>{...(selectedAnswers ?? []), ans.id});
          },
        );
      },
    );
  }
}

class SliderHAnsewrComponent extends StatelessWidget {
  final List<TAnswer> answers;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;

  const SliderHAnsewrComponent({
    super.key,
    required this.answers,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sliderValue = answers.indexWhere((e) => e.id == selectedAnswer);
    final answerLabel = answers
        .firstWhere(
          (e) => e.id == selectedAnswer,
          orElse: () => (
            id: answers.first.id as String,
            label: answers.first.label,
          ),
        )
        .label;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: Text("Select your option:"),
        ),
        Expanded(
          child: Text(
            answerLabel,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF2970FE),
              fontSize: 30,
              fontFamily: 'Lexend',
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          child: Slider(
            thumbColor: const Color(0xFF155EEF),
            activeColor: const Color(0xFF155EEF),
            min: 1,
            divisions: answers.length,
            max: answers.length.toDouble(),
            label: answerLabel,
            value: (sliderValue > -1 ? sliderValue.toDouble() : 0) + 1,
            onChanged: (nvalue) {
              onAnswerSelected(answers[nvalue.ceil() - 1].id);
            },
          ),
        )
      ],
    );
  }
}

class SliderVAnsewrComponent extends StatelessWidget {
  final List<TAnswer> answers;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;

  const SliderVAnsewrComponent({
    super.key,
    required this.answers,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    final sliderValue = answers.indexWhere((e) => e.id == selectedAnswer);
    final answerLabel = answers
        .firstWhere(
          (e) => e.id == selectedAnswer,
          orElse: () => (
            id: answers.first.id as String,
            label: answers.first.label,
          ),
        )
        .label;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 8.0, bottom: 16),
          child: Text("Select your option:"),
        ),
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  answerLabel,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Color(0xFF2970FE),
                    fontSize: 30,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              Transform(
                alignment: FractionalOffset.center,
                // Rotate sliders by 90 degrees
                transform: Matrix4.identity()..rotateZ(90 * 3.1415927 / 180),
                child: Slider(
                  thumbColor: const Color(0xFF155EEF),
                  activeColor: const Color(0xFF155EEF),
                  min: 1,
                  divisions: answers.length,
                  max: answers.length.toDouble(),
                  // label: answerLabel,
                  value: (sliderValue > -1 ? sliderValue.toDouble() : 0) + 1,
                  onChanged: (nvalue) {
                    onAnswerSelected(answers[nvalue.ceil() - 1].id);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class BoolAnsewrComponent extends StatefulWidget {
  final String? selectedAnswer;
  final Function(String, String) onAnswerSelected;
  final bool hasComment;
  final String comment;

  const BoolAnsewrComponent({
    super.key,
    required this.selectedAnswer,
    required this.onAnswerSelected,
    this.comment = "",
    this.hasComment = false,
  });

  @override
  State<BoolAnsewrComponent> createState() => _BoolAnsewrComponentState();
}

class _BoolAnsewrComponentState extends State<BoolAnsewrComponent> {
  late final TextEditingController commentBoxController;

  @override
  void initState() {
    super.initState();
    commentBoxController = TextEditingController(text: widget.comment);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: QCheckButton(
                onSelected: () => widget.onAnswerSelected("No", widget.comment),
                label: "No",
                isSelected: widget.selectedAnswer == "No",
              ),
            ),
            const SizedBox(width: 15),
            Expanded(
              child: QCheckButton(
                onSelected: () =>
                    widget.onAnswerSelected("Yes", widget.comment),
                label: "Yes",
                isSelected: widget.selectedAnswer == "Yes",
              ),
            ),
          ],
        ),
        if (widget.hasComment)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: commentBoxController,
              minLines: 5,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.grey.shade200,
                  ),
                ),
              ),
              onEditingComplete: () => widget.onAnswerSelected(
                widget.selectedAnswer ?? "No",
                commentBoxController.text,
              ),
            ),
          )
      ],
    );
  }
}
