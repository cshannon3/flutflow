
// Want text field/ text editor
// want text wrap around, and angles etc
import 'dart:math' as math;
import 'dart:ui' as ui;
//https://github.com/suragch/mongol/blob/master/lib/mongol_paragraph.dart
import 'package:flutter/painting.dart';

import 'package:flutter/widgets.dart';
import 'dart:ui' as ui show ParagraphStyle;

class MongolText extends StatelessWidget {
  const MongolText(
    this.data, {
    Key key,
    this.style,
  })  : assert(data != null, 'The data cannot be null.'),
        super(key: key);

  /// This is the text that the MongolText widget will display.
  final String data;

  /// This is the style to use for the whole text string. If null a default
  /// style will be used.
  final TextStyle style;

  static const TextStyle _defaultMongolTextStyle =
      TextStyle(fontSize: 24.0);

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    TextStyle effectiveTextStyle = style;
    if (style == null || style.inherit) {
      effectiveTextStyle = _defaultMongolTextStyle.merge(style);
      effectiveTextStyle = defaultTextStyle.style.merge(effectiveTextStyle);
    }

    Widget result = MongolRichText(
      text: TextSpan(
        text: data,
        style: effectiveTextStyle,
      ),
    );
    return result;
  }
}
class MongolRichText extends LeafRenderObjectWidget {
  /// Creates a single line of vertical text
  ///
  /// The [text] argument must not be null.
  const MongolRichText({
    Key key,
    this.text,
  })  : assert(text != null),
        super(key: key);

  /// The text to display in this widget.
  final TextSpan text;

  @override
  MongolRenderParagraph createRenderObject(BuildContext context) {
    return MongolRenderParagraph(text);
  }

  @override
  void updateRenderObject(
      BuildContext context, MongolRenderParagraph renderObject) {
    renderObject.text = text;
  }
}

class MongolRenderParagraph extends RenderBox {
  /// Creates a vertical text render object.
  ///
  /// The [text] argument must not be null.
  MongolRenderParagraph(TextSpan text)
      : assert(text != null),
        _textPainter = MongolTextPainter(text: text);

  final MongolTextPainter _textPainter;

  /// The text to display
  TextSpan get text => _textPainter.text;

  set text(TextSpan value) {
    switch (_textPainter.text.compareTo(value)) {
      case RenderComparison.identical:
      case RenderComparison.metadata:
        return;
      case RenderComparison.paint:
        _textPainter.text = value;
        markNeedsPaint();
        break;
      case RenderComparison.layout:
        _textPainter.text = value;
        markNeedsLayout();
        break;
    }
  }

  void _layoutText({
    double minHeight = 0.0,
    double maxHeight = double.infinity,
  }) {
    _textPainter.layout(
      minHeight: minHeight,
      maxHeight: maxHeight,
    );
  }

  void _layoutTextWithConstraints(BoxConstraints constraints) {
    _layoutText(
      minHeight: constraints.minHeight,
      maxHeight: constraints.maxHeight,
    );
  }

  @override
  double computeMinIntrinsicHeight(double width) {
    _layoutText();
    return _textPainter.minIntrinsicHeight;
  }

  @override
  double computeMaxIntrinsicHeight(double width) {
    _layoutText();
    return _textPainter.maxIntrinsicHeight;
  }

  double _computeIntrinsicWidth(double height) {
    _layoutText(minHeight: height, maxHeight: height);
    return _textPainter.width;
  }

  @override
  double computeMinIntrinsicWidth(double height) {
    return _computeIntrinsicWidth(height);
  }

  @override
  double computeMaxIntrinsicWidth(double height) {
    return _computeIntrinsicWidth(height);
  }

  @override
  double computeDistanceToActualBaseline(TextBaseline baseline) {
    assert(!debugNeedsLayout);
    assert(constraints != null);
    assert(constraints.debugAssertIsValid());
    _layoutTextWithConstraints(constraints);
    // Since the text is rotated it doesn't make sense to use the rotated
    // text baseline because this is used for aligning with other widgets.
    // Instead we will return the base of the widget.
    return _textPainter.height;
  }

  @override
  void performLayout() {
    _layoutTextWithConstraints(constraints);
    final Size textSize = _textPainter.size;
    size = constraints.constrain(textSize);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    _layoutTextWithConstraints(constraints);
    _textPainter.paint(context.canvas, offset);
  }
}
class MongolParagraph {
  /// To create a [MongolParagraph] object, use a [MongolParagraphBuilder].
  MongolParagraph._(this._paragraphStyle, this._textStyle, this._text,);

  static const _newLineCodeUnit = 10;

  ui.ParagraphStyle _paragraphStyle;
  ui.TextStyle _textStyle;
  String _text;


  double _width;
  double _height;
  double _minIntrinsicHeight;
  double _maxIntrinsicHeight;

  double get width => _width;

  double get height => _height;

  double get minIntrinsicHeight => _minIntrinsicHeight;

  double get maxIntrinsicHeight => _maxIntrinsicHeight;

  void layout(MongolParagraphConstraints constraints) =>
      _layout(constraints.height);

  void _layout(double height) {
    if (height == _height) return;
    _calculateRuns();
    _calculateLineBreaks(height);
    _calculateWidth();
    _height = height;
    _calculateIntrinsicHeight();
  }

  List<TextRun> _runs = [];

  void _calculateRuns() {
    if (_runs.isNotEmpty) return;

    // go through text find break location
    final breaker = LineBreaker();
    breaker.text = _text;
    final int breakCount = breaker.computeBreaks();
    final breaks = breaker.breaks;

    // build paragraph for each run
    int start = 0;
    int end;
    for (int i = 0; i < breakCount; i++) {
      end = breaks[i];
      _addRun(start, end);
      start = end;
    }
    end = _text.length;
    if (start < end) {
      _addRun(start, end);
    }
  }

  void _addRun(int start, int end) {
    final endIgnoringNewLineChar = _isNewLineCharAt(end - 1)
        ? end - 1
        : end;
    final builder = ui.ParagraphBuilder(_paragraphStyle)
      ..pushStyle(_textStyle)
      ..addText(_text.substring(start, endIgnoringNewLineChar));
    final paragraph = builder.build();
    paragraph.layout(ui.ParagraphConstraints(width: double.infinity));

    final run = TextRun(start, end, paragraph);
    _runs.add(run);
  }

  bool _isNewLineCharAt(int index) {
    return _text.codeUnitAt(index) == _newLineCodeUnit;
  }

  List<LineInfo> _lines = [];

  // Internally this method uses "width" and "height" naming with regard
  // to a horizontal line of text. Rotation doesn't happen until drawing.
  void _calculateLineBreaks(double maxLineLength) {
    assert(_runs != null);
    if (_runs.isEmpty) {
      return;
    }
    if (_lines.isNotEmpty) {
      _lines.clear();
    }

    // add run lengths until exceeds height
    int start = 0;
    int end;
    double lineWidth = 0;
    double lineHeight = 0;
    for (int i = 0; i < _runs.length; i++) {
      end = i;
      final run = _runs[i];
      final runWidth = run.paragraph.maxIntrinsicWidth;
      final runHeight = run.paragraph.height;

      if (_runEndsWithNewLine(run)) {
        end = i + 1;
        lineWidth += runWidth;
        lineHeight = math.max(lineHeight, run.paragraph.height);
        _addLine(start, end, lineWidth, lineHeight);
        lineWidth = 0;
        lineHeight = 0;
        start = end;
      } else if (lineWidth + runWidth > maxLineLength) {
        _addLine(start, end, lineWidth, lineHeight);
        start = end;
        lineWidth = runWidth;
        lineHeight = runHeight;
      } else {
        lineWidth += runWidth;
        lineHeight = math.max(lineHeight, run.paragraph.height);
      }
    }

    end = _runs.length;
    if (start < end) {
      _addLine(start, end, lineWidth, lineHeight);
    }
  }

  bool _runEndsWithNewLine(TextRun run) {
    return _isNewLineCharAt(run.end - 1);
  }

  void _addLine(int start, int end, double width, double height) {
    final bounds = Rect.fromLTRB(0, 0, width, height);
    final LineInfo lineInfo = LineInfo(start, end, bounds);
    _lines.add(lineInfo);
  }

  void _calculateWidth() {
    assert(_lines != null);
    assert(_runs != null);
    double sum = 0;
    for (LineInfo line in _lines) {
      sum += line.bounds.height;
    }
    _width = sum;
  }

  // Internally this translates a horizontal run width to the vertical name
  // that it is known as externally.
  // FIXM: This does not handle newline characters.
  void _calculateIntrinsicHeight() {
    assert(_runs != null);

    double sum = 0;
    double maxRunWidth = 0;
    double maxLineLength = 0;
    for (LineInfo line in _lines) {
      for (int i = line.textRunStart; i < line.textRunEnd; i++) {
        final width = _runs[i].paragraph.maxIntrinsicWidth;
        maxRunWidth = math.max(width, maxRunWidth);
        sum += width;
      }
      maxLineLength = math.max(maxLineLength, sum);
      sum = 0;
    }
    _minIntrinsicHeight = maxRunWidth;
    _maxIntrinsicHeight = maxLineLength;
  }

  void draw(Canvas canvas, Offset offset) {
    assert(_lines != null);
    assert(_runs != null);


    // translate for the offset
    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    // rotate the canvas 90 degrees
    canvas.rotate(math.pi / 2);

    // loop through every line
    for (LineInfo line in _lines) {

      // translate for the line height
      canvas.translate(0, -line.bounds.height);

      // draw each run in the current line
      double dx = 0;
      for (int i = line.textRunStart; i < line.textRunEnd; i++) {
        canvas.drawParagraph(_runs[i].paragraph, Offset(dx, 0));
        dx += _runs[i].paragraph.longestLine;
      }
    }

    canvas.restore();
  }


}

class MongolParagraphConstraints {
  const MongolParagraphConstraints({
    this.height,
  }) : assert(height != null);

  final double height;

  @override
  bool operator ==(dynamic other) {
    if (other.runtimeType != runtimeType) return false;
    final MongolParagraphConstraints typedOther = other;
    return typedOther.height == height;
  }

  @override
  int get hashCode => height.hashCode;

  @override
  String toString() => '$runtimeType(height: $height)';
}

class MongolParagraphBuilder {

  MongolParagraphBuilder(ui.ParagraphStyle style) {
    _paragraphStyle = style;
  }

  ui.ParagraphStyle _paragraphStyle;
  ui.TextStyle _textStyle;
  String _text = '';

  static final _defaultParagraphStyle = ui.ParagraphStyle(
    textAlign: TextAlign.start,
    textDirection: TextDirection.ltr,
    fontSize: 30,
    //fontFamily: MongolFont.qagan,
  );
  static final  _defaultTextStyle = ui.TextStyle(
    color: Color(0xFF000000),
    textBaseline: TextBaseline.alphabetic,
    fontSize: 30,
  );

  // The current implementation replaces the old style.
  // TODO: create a stack of styles to push and pop
  void pushStyle(TextStyle style) {
    _textStyle = style.getTextStyle();
  }

  // The current implementation does nothing.
  // TODO: remove the last style from a stack of styles.
  void pop() { }

  // The current implementation does appends the text.
  // TODO: associate the added text with a style.
  void addText(String text) {
    _text += text;
  }

  MongolParagraph build() {
    assert(_text != null);
    if (_paragraphStyle == null) {
      _paragraphStyle = _defaultParagraphStyle;
    }
    if (_textStyle == null) {
      _textStyle = _defaultTextStyle;
    }

    return MongolParagraph._(_paragraphStyle, _textStyle, _text);
  }
}

class LineBreaker {
  String _text;
  List<int> _breaks;

  set text(String text) {
    if (text == _text) {
      return;
    }
    _text = text;
    _breaks = null;
  }

  // returns the number of breaks
  int computeBreaks() {
    assert(_text != null);

    if (_breaks != null) {
      return _breaks.length;
    }
    _breaks = [];

    for (int i = 1; i < _text.length; i++) {
      if (isBreakChar(_text[i - 1]) && !isBreakChar(_text[i])) {
        _breaks.add(i);
      }
    }

    return _breaks.length;
  }

  List<int> get breaks => _breaks;

  bool isBreakChar(String codeUnit) {
    return codeUnit == ' ' || codeUnit == '\n';
  }
}

class TextRun {
  TextRun(this.start, this.end, this.paragraph);
  int start;
  int end;
  ui.Paragraph paragraph;
}

class LineInfo {
  LineInfo(this.textRunStart, this.textRunEnd, this.bounds);

  int textRunStart;
  int textRunEnd;
  Rect bounds;
}



class MongolTextPainter {
  MongolTextPainter({
    TextSpan text,
  })  : assert(text == null || text.debugAssertIsValid()),
        _text = text;

  MongolParagraph _paragraph;
  bool _needsLayout = true;

  TextSpan get text => _text;
  TextSpan _text;

  set text(TextSpan value) {
    assert(value == null || value.debugAssertIsValid());
    if (_text == value) return;
    _text = value;
    _paragraph = null;
    _needsLayout = true;
  }

  ui.ParagraphStyle _createParagraphStyle() {
    return ui.ParagraphStyle(
      textAlign: TextAlign.start,
      textDirection: TextDirection.ltr,
      maxLines: null,
      ellipsis: null,
      locale: null,
    );
  }

  double _applyFloatingPointHack(double layoutValue) {
    return layoutValue.ceilToDouble();
  }

  double get minIntrinsicHeight {
    assert(!_needsLayout);
    return _applyFloatingPointHack(_paragraph.minIntrinsicHeight);
  }

  double get maxIntrinsicHeight {
    assert(!_needsLayout);
    return _applyFloatingPointHack(_paragraph.maxIntrinsicHeight);
  }

  double get width {
    assert(!_needsLayout);
    return _applyFloatingPointHack(_paragraph.width);
  }

  double get height {
    assert(!_needsLayout);
    return _applyFloatingPointHack(_paragraph.height);
  }

  Size get size {
    assert(!_needsLayout);
    return Size(width, height);
  }

  double _lastMinHeight;
  double _lastMaxHeight;

  void layout({double minHeight = 0.0, double maxHeight = double.infinity}) {
    assert(text != null);
    if (!_needsLayout &&
        minHeight == _lastMinHeight &&
        maxHeight == _lastMaxHeight) return;
    _needsLayout = false;
    if (_paragraph == null) {
      final MongolParagraphBuilder builder =
          MongolParagraphBuilder(_createParagraphStyle());
      _addStyleToText(builder, _text);
      _paragraph = builder.build();
    }
    _lastMinHeight = minHeight;
    _lastMaxHeight = maxHeight;
    _paragraph.layout(MongolParagraphConstraints(height: maxHeight));
    if (minHeight != maxHeight) {
      final double newHeight = maxIntrinsicHeight.clamp(minHeight, maxHeight);
      if (newHeight != height)
        _paragraph.layout(MongolParagraphConstraints(height: newHeight));
    }
  }

  void _addStyleToText(MongolParagraphBuilder builder, TextSpan textSpan) {
    final style = textSpan.style;
    final text = textSpan.text;
    final children = textSpan.children;
    final bool hasStyle = style != null;
    if (hasStyle) builder.pushStyle(style);
    if (text != null) builder.addText(text);
    if (children != null) {
      for (TextSpan child in children) {
        assert(child != null);
        _addStyleToText(builder, child);
      }
    }
    if (hasStyle) builder.pop();
  }

  void paint(Canvas canvas, Offset offset) {
    _paragraph.draw(canvas, offset);
  }
}