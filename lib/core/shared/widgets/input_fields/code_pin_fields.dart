import 'package:flutter/material.dart';
import 'package:flutter_template_app/theme/theme_color.dart';

class CodePinFields extends StatefulWidget {
  final int numberOfFields;
  final bool obscureText;
  final TextInputType textInputType;
  final Function(String value) codeEntered;
  final String initialValue;
  const CodePinFields({
    super.key,
    required this.numberOfFields,
    required this.codeEntered,
    this.obscureText = false,
    this.textInputType = TextInputType.text,
    this.initialValue = '',
  });

  @override
  State<CodePinFields> createState() => _CodePinFieldsState();
}

class _CodePinFieldsState extends State<CodePinFields> {
  // final TicketsProvider ticketsProvider = TicketsProvider();

  /// List of focus node controllers used to handle focus changes on input fields
  List<FocusNode> focusList = [];

  /// List of the text input controllers
  List<TextEditingController> controllerList = [];

  /// Helper variable used to change the submit button state
  // bool isButtonDisabled = true;
  // bool isLoading = false;

  /// Space between inputs
  double spaceBeetweenPins = 3;
  String errorMessage = '';
  String stateError = '';
  double borderRadius = 12;

  @override
  void initState() {
    super.initState();
    focusList = List<FocusNode>.generate(widget.numberOfFields, (index) => FocusNode());
    List<String> initialValueList = widget.initialValue.split('');
    controllerList = List<TextEditingController>.generate(
      widget.numberOfFields,
      (index) {
        String value = '';
        if (initialValueList.isNotEmpty) {
          value = initialValueList[index];
        }
        return TextEditingController(text: value);
      },
    );
  }

  @override
  void dispose() {
    controllerList.map((controller) => controller.dispose());
    focusList.map((node) => node.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
                child: Center(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [for (var i = 0; i < focusList.length; i++) _buildPin(controllerList[i], focusList[i], i)],
                ),
              ),
            )),
          ],
        ),
      ],
    );
  }

  _buildPin(TextEditingController controller, FocusNode focusNode, int index) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 48,
          margin: EdgeInsets.only(right: spaceBeetweenPins),
          decoration: BoxDecoration(
            color: AppColors.baseWhite,
            // color: context.colors.baseWhite,
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          child: TextFormField(
            keyboardType: widget.textInputType,
            obscureText: widget.obscureText,
            cursorColor: AppColors.primaryText,
            textAlign: TextAlign.center,
            focusNode: focusNode,
            controller: controller,
            onTap: () {
              controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
              setState(() {
                cleanAllInputsOnRight(index);
              });
            },
            onChanged: (value) {
              // Detect if it is a paste operation - more than one letter in value
              List<String> valueList = value.trim().replaceAll('-', '').split('');
              if (valueList.length > 1) {
                setState(() {
                  pasteFromClipboard(valueList);
                });
                return;
              }
              setState(() {
                if (controller.text.isEmpty) {
                  controller.text = ' ';
                  changeFocusToPreviousField(index);
                } else {
                  controller.text = controller.text.toUpperCase();
                  changeFocusToNextField(index);
                }
                controller.selection = TextSelection(baseOffset: 0, extentOffset: controller.text.length);
              });
              widget.codeEntered(_getAllCodesAsString());

              // print(_getAllCodesAsString());
            },
            validator: (value) {
              return validateInput(value!);
            },
            showCursor: false,
            style: const TextStyle(fontSize: 20, color: AppColors.primaryText, fontWeight: FontWeight.w700),
            decoration: InputDecoration(
              // fillColor: context.colors.baseWhite,
              // isDense: true,
              contentPadding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              // fillColor: AppColors.primaryGray,
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                borderSide: const BorderSide(color: AppColors.textBlue),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
                borderSide: const BorderSide(color: AppColors.primaryText),
              ),
            ),
          ),
        ),
      ],
    );
  }

  changeFocusToNextField(int currentIndex) {
    if (currentIndex == focusList.length - 1) {
      return;
    }
    FocusNode nextInput = focusList[currentIndex + 1];
    FocusScope.of(context).requestFocus(nextInput);
    controllerList[currentIndex + 1].selection =
        TextSelection(baseOffset: 0, extentOffset: controllerList[currentIndex + 1].text.length);
  }

  changeFocusToPreviousField(int currentIndex) {
    if (currentIndex == 0) {
      return;
    }
    FocusNode previousInput = focusList[currentIndex - 1];
    FocusScope.of(context).requestFocus(previousInput);
    controllerList[currentIndex - 1].selection =
        TextSelection(baseOffset: 0, extentOffset: controllerList[currentIndex - 1].text.length);
  }

  cleanAllInputsOnRight(int currentIndex) {
    for (var i = 0; i < controllerList.length; i++) {
      if (i >= currentIndex) {
        TextEditingController controller = controllerList[i];
        controller.text = ' ';
      }
    }
    // Move focus to first empty field
    changeFocusToFirstEmptyField();
  }

  changeFocusToFirstEmptyField() {
    for (var i = 0; i < controllerList.length; i++) {
      TextEditingController controller = controllerList[i];
      if (controller.text == ' ') {
        FocusNode emptyInput = focusList[i];
        FocusScope.of(context).requestFocus(emptyInput);
        controllerList[i].selection = TextSelection(baseOffset: 0, extentOffset: controllerList[i].text.length);
        break;
      }
    }
  }

  pasteFromClipboard(List<String> list) {
    for (var i = 0; i < list.length; i++) {
      String letter = list[i];
      // if it is last input then stop
      if (i == controllerList.length) {
        break;
      }

      TextEditingController controller = controllerList[i];
      controller.text = letter.toUpperCase();
    }
    widget.codeEntered(_getAllCodesAsString());
    ();
  }

  validateInput(String value) {
    // TODO: Implement
  }

  _getAllCodesAsString() {
    String code = '';
    for (var i = 0; i < controllerList.length; i++) {
      TextEditingController controller = controllerList[i];
      code += controller.text;
    }
    return code.trim();
  }

  // _chekIfCodeIsEntered() {
  //   String codeString = _getAllCodesAsString();
  //   if (codeString.length == widget.numberOfFields) {
  //     widget.codeEntered(_getAllCodesAsString());
  //   }
  // }
}
