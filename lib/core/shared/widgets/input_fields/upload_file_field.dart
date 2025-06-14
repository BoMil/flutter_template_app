// import 'dart:io';
// import 'package:file_picker/file_picker.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_template_app/theme/input_styles.dart';
// import 'package:flutter_template_app/theme/theme_color.dart';

// class UploadFileField extends StatefulWidget {
//   final String labelText;
//   final String placeholderText;
//   final bool? readOnly;
//   final Function(File file)? onFileUploaded;
//   final Function()? onFileCancel;
//   final Color? labelColor;
//   final EdgeInsetsGeometry contentPadding;
//   final double minContainerHeight;
//   final Function(bool)? onFocusChanged;
//   final String? Function(String? value)? customValidator;
//   final List<String> allowedFileExtensions;
//   final String extensionErrMessage;
//   final double maxFileSize;
//   final File? preselectedFile;

//   const UploadFileField({
//     super.key,
//     this.labelText = '',
//     this.placeholderText = '',
//     this.readOnly = false,
//     this.onFileUploaded,
//     this.onFileCancel,
//     this.labelColor,
//     this.contentPadding = const EdgeInsets.only(bottom: 19, left: 16, top: 19),
//     this.onFocusChanged,
//     this.minContainerHeight = 83,
//     this.customValidator,
//     this.allowedFileExtensions = const ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'jpg', 'jpeg', 'png', 'webp'],
//     this.extensionErrMessage = 'Invalid Extension',
//     this.maxFileSize = 10 * 1024 * 1024, // 40MB
//     this.preselectedFile,
//   });

//   @override
//   State<UploadFileField> createState() => _UploadFileFieldState();
// }

// const int maxFileNameLength = 40; // Maksimalna dozvoljena dužina

// String shortenFileName(String fileName, int maxLength) {
//   if (fileName.length <= maxLength) {
//     return fileName;
//   }
//   // Skratiti ime i dodati tri tačke
//   return '${fileName.substring(0, maxLength - 3)}...';
// }

// class _UploadFileFieldState extends State<UploadFileField> {
//   // ignore: unused_field
//   double _uploadProgress = 0.0; // Upload progress
//   String? _uploadedFileName; // Display the uploaded file name
//   File? _uploadedFile; // Actual file reference
//   final FocusNode _focusNode = FocusNode();

//   bool _validateFile(FilePickerResult? result) {
//     if (result != null) {
//       for (var file in result.files) {
//         if (!widget.allowedFileExtensions.contains(file.extension)) {
//           ToastMessage().showErrorToast(text: widget.extensionErrMessage);
//           return false;
//         } else if (file.size > widget.maxFileSize) {
//           ToastMessage()
//               .showErrorToast(text: AppLocalizations.of(context).fileSizeExceeded('${widget.maxFileSize / 1024}'));
//           return false;
//         }
//       }

//       return true;
//     }
//     return false;
//   }

//   void _selectFile() async {
//     // Otvaranje dijaloga za izbor fajla
//     FilePickerResult? result = await FilePicker.platform.pickFiles();

//     if (!_validateFile(result)) {
//       return;
//     }

//     if (result != null) {
//       String? filePath = result.files.single.path;

//       setState(() {
//         _uploadProgress = 0.1; // Početak upload-a
//         _uploadedFile = File(filePath);
//       });

//       // Simulacija završetka upload-a
//       // await Future.delayed(const Duration(seconds: 1));
//       setState(() {
//         _uploadedFileName = shortenFileName(result.files.single.name, maxFileNameLength); // Prikazuje ime fajla
//         _uploadProgress = 1.0;

//         // Poziv callback-a ako je definisan
//         if (widget.onFileUploaded != null) {
//           widget.onFileUploaded!(_uploadedFile!);
//         }
//       });
//     } else {
//       // Korisnik je otkazao izbor fajla
//       setState(() {
//         _uploadProgress = 0.0;
//       });
//     }
//   }

//   void _removeFile() {
//     setState(() {
//       _uploadedFileName = null;
//       _uploadedFile = null;
//       _uploadProgress = 0.0;

//       widget.onFileCancel!();
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     if (widget.preselectedFile != null) {
//       setState(() {
//         _uploadedFileName = shortenFileName(widget.preselectedFile!.path.split('/').last, maxFileNameLength);
//         _uploadedFile = widget.preselectedFile;
//       });
//     }
//     if (widget.onFocusChanged == null) {
//       return;
//     }
//     _focusNode.addListener(_onFocusChange);
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     _focusNode.removeListener(_onFocusChange);
//     _focusNode.dispose();
//   }

//   void _onFocusChange() {
//     widget.onFocusChanged?.call(_focusNode.hasFocus);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       height: widget.minContainerHeight,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           if (widget.labelText.isNotEmpty)
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0),
//               child: Text(
//                 widget.labelText,
//                 style: TextStyle(color: widget.labelColor ?? ThemeConfig().themeColor.primaryText, fontSize: 14),
//               ),
//             ),
//           TextFormField(
//             focusNode: _focusNode,
//             readOnly: true,
//             style: const TextStyle(color: AppColors.primaryText),
//             decoration: InputStyles.primaryInputDecoration(
//               fillColor: ThemeConfig().themeColor.secondaryBackground,
//               borderColor: Colors.transparent,
//               lableText: _uploadedFileName == null ? widget.placeholderText : '',
//               suffix: _uploadedFileName == null
//                   ? Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//                       child: OutlinedButton(
//                         onPressed: widget.readOnly == true ? null : _selectFile,
//                         style: OutlinedButton.styleFrom(
//                           padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),
//                           side: BorderSide(color: ThemeConfig().themeColor.primaryBackground, width: 1),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           backgroundColor: Colors.transparent,
//                         ),
//                         child: Text(
//                           'Select File',
//                           style: TextStyle(fontSize: 12, color: ThemeConfig().themeColor.primaryText),
//                         ),
//                       ),
//                     )
//                   : Padding(
//                       padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Expanded(
//                             child: Text(
//                               _uploadedFileName!,
//                               style: const TextStyle(fontSize: 12),
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                           ),
//                           IconButton(
//                             onPressed: _removeFile,
//                             icon: const Icon(Icons.cancel, size: 18, color: Colors.red),
//                           ),
//                         ],
//                       ),
//                     ),
//               contentPadding: widget.contentPadding,
//             ),
//             validator: (value) {
//               if (widget.customValidator != null) {
//                 return widget.customValidator!(value);
//               }
//               if (value == null || value.isEmpty) {
//                 return TranslationStorage.translation.fieldIsRequired;
//               }
//               return null;
//             },
//           ),
//         ],
//       ),
//     );
//   }
// }
