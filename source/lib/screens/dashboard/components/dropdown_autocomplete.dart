import 'package:flutter/material.dart';

class DropdownAutocompleteFormField extends StatefulWidget {
  final List<String> optionsList;
  final String hintText;

  const DropdownAutocompleteFormField({
    Key? key,
    required this.optionsList,
    this.hintText = 'Selecione uma opção...',
  }) : super(key: key);

  @override
  _DropdownAutocompleteFormFieldState createState() =>
      _DropdownAutocompleteFormFieldState();
}

class _DropdownAutocompleteFormFieldState
    extends State<DropdownAutocompleteFormField> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  List<String> _filteredOptions = [];
  OverlayEntry? _overlayEntry;
  bool _isDropdownOpened = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChanged);
    _controller.addListener(_onTextChanged);
    _filteredOptions = widget.optionsList;
  }

  void _onTextChanged() {
    setState(() {
      _filteredOptions = widget.optionsList
          .where((option) =>
              option.toLowerCase().contains(_controller.text.toLowerCase()))
          .toList();
      if (!_isDropdownOpened) {
        _openDropdown();
      }
    });
  }

  void _onFocusChanged() {
    if (_focusNode.hasFocus) {
      _openDropdown();
    } else {
      _closeDropdown();
    }
  }

  void _openDropdown() {
    if (_overlayEntry == null) {
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context)!.insert(_overlayEntry!);
      setState(() => _isDropdownOpened = true);
    }
  }

  void _closeDropdown() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      setState(() => _isDropdownOpened = false);
    }
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height,
        width: size.width,
        child: Material(
          elevation: 4.0,
          child: ListView.builder(
            padding: EdgeInsets.zero,
            shrinkWrap: true,
            itemCount: _filteredOptions.length,
            itemBuilder: (BuildContext context, int index) {
              final option = _filteredOptions[index];
              return ListTile(
                title: Text(option),
                onTap: () {
                  _controller.text = option;
                  _closeDropdown();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: LayerLink(),
      child: TextFormField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: widget.hintText,
          suffixIcon: Icon(
              _isDropdownOpened ? Icons.arrow_drop_up : Icons.arrow_drop_down),
        ),
        readOnly: true,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    _closeDropdown();
    super.dispose();
  }
}
