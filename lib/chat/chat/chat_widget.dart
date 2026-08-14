import '/backend/supabase/supabase.dart';
import '/chat/message_bubble/message_bubble_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'chat_model.dart';
export 'chat_model.dart';

class ChatWidget extends StatefulWidget {
  const ChatWidget({
    super.key,
    required this.id,
    required this.user,
  });

  final String? id;
  final String? user;

  static String routeName = 'Chat';
  static String routePath = '/chat';

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> with RouteAware {
  late ChatModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();

  List<ChatMessagesRow> _messages = [];
  bool _isLoading = true;
  bool _isSending = false;
  bool _isDisposed = false;
  RealtimeChannel? _channel;
  String? _conversationId;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => ChatModel());

    _model.messageBodyFieldTextController ??= TextEditingController()
      ..addListener(() {
        debugLogWidgetClass(_model);
      });
    _model.messageBodyFieldFocusNode ??= FocusNode();

    _initChat();
  }

  Future<void> _initChat() async {
    if (_isDisposed || !mounted) return;
    // Find or create conversation via RPC (idempotent — safe to call every open)
    final result = await SupaFlow.client.rpc(
      'create_conversation',
      params: {'other_user_id': widget.id ?? ''},
    );
    if (_isDisposed || !mounted) return;
    _conversationId = result as String;
    await _loadMessages();
    _subscribeToMessages();
  }

  Future<void> _loadMessages() async {
    if (_isDisposed || !mounted) return;
    if (_conversationId == null) {
      setState(() => _isLoading = false);
      return;
    }
    final messages = await ChatMessagesTable().queryRows(
      queryFn: (q) => q
          .eq('conversation_id', _conversationId!)
          .order('created_at', ascending: false),
    );
    if (_isDisposed || !mounted) return;
    setState(() {
      _messages = messages;
      _isLoading = false;
    });
  }

  void _subscribeToMessages() {
    _channel = SupaFlow.client
        .channel('chat_${FFAppState().LoggedInUserUUID}_${widget.id}')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) {
            if (!_isDisposed && mounted) _loadMessages();
          },
        )
        .subscribe();
  }


  Future<void> _sendMessage() async {
    final text =
        _model.messageBodyFieldTextController?.text.trim() ?? '';
    if (text.isEmpty || _isSending || _isDisposed) return;

    if (mounted) setState(() => _isSending = true);

    try {
      await ChatMessagesTable().insert({
        'conversation_id': _conversationId,
        'sender_id': FFAppState().LoggedInUserUUID,
        'body': text,
      });
      if (!_isDisposed && mounted) {
        safeSetState(() {
          _model.messageBodyFieldTextController?.clear();
          _isSending = false;
        });
        await _loadMessages();
      }
    } catch (e) {
      if (!_isDisposed && mounted) setState(() => _isSending = false);
    }
  }

  @override
  void deactivate() {
    _isDisposed = true;
    _channel?.unsubscribe();
    _channel = null;
    super.deactivate();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _scrollController.dispose();
    _model.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(ChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    _model.widget = widget;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = DebugModalRoute.of(context);
    if (route != null) {
      routeObserver.subscribe(this, route);
    }
    debugLogGlobalProperty(context);
  }

  @override
  void didPopNext() {
    if (mounted && DebugFlutterFlowModelContext.maybeOf(context) == null) {
      setState(() => _model.isRouteVisible = true);
      debugLogWidgetClass(_model);
    }
  }

  @override
  void didPush() {
    if (mounted && DebugFlutterFlowModelContext.maybeOf(context) == null) {
      setState(() => _model.isRouteVisible = true);
      debugLogWidgetClass(_model);
    }
  }

  @override
  void didPop() {
    _model.isRouteVisible = false;
  }

  @override
  void didPushNext() {
    _model.isRouteVisible = false;
  }

  @override
  Widget build(BuildContext context) {
    DebugFlutterFlowModelContext.maybeOf(context)
        ?.parentModelCallback
        ?.call(_model);
    context.watch<FFAppState>();
    _model.messageBubbleModels.clear();

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  // Message list
                  Positioned.fill(
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 0.0, 10.0, 10.0),
                      child: _isLoading
                          ? Center(
                              child: SizedBox(
                                width: 50.0,
                                height: 50.0,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    FlutterFlowTheme.of(context).primary,
                                  ),
                                ),
                              ),
                            )
                          : _messages.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline_rounded,
                                        size: 64.0,
                                        color: FlutterFlowTheme.of(context)
                                            .secondaryText,
                                      ),
                                      const SizedBox(height: 12.0),
                                      Text(
                                        'No messages yet.\nSay hello!',
                                        textAlign: TextAlign.center,
                                        style: FlutterFlowTheme.of(context)
                                            .bodyMedium
                                            .override(
                                              font: GoogleFonts.inter(
                                                fontWeight:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontWeight,
                                                fontStyle:
                                                    FlutterFlowTheme.of(context)
                                                        .bodyMedium
                                                        .fontStyle,
                                              ),
                                              color: FlutterFlowTheme.of(
                                                      context)
                                                  .secondaryText,
                                              letterSpacing: 0.0,
                                            ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  controller: _scrollController,
                                  padding: const EdgeInsets.fromLTRB(
                                    0,
                                    150.0,
                                    0,
                                    10.0,
                                  ),
                                  reverse: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: _messages.length,
                                  itemBuilder: (context, listViewIndex) {
                                    final msg = _messages[listViewIndex];
                                    return Builder(builder: (_) {
                                      return DebugFlutterFlowModelContext(
                                        rootModel: _model.rootModel,
                                        parentModelCallback: (m) {
                                          _model.messageBubbleModels[
                                              'Keyekx_${listViewIndex}_of_${_messages.length}'] = m;
                                        },
                                        child: MessageBubbleWidget(
                                          key: Key(
                                              'Keyekx_${listViewIndex}_of_${_messages.length}'),
                                          fromMe:
                                              FFAppState().LoggedInUserUUID ==
                                                  msg.senderId,
                                          messageBody: msg.body ?? '',
                                          sentAt: msg.createdAt,
                                        ),
                                      );
                                    });
                                  },
                                ),
                    ),
                  ),
                  // Header with gradient
                  Container(
                    width: MediaQuery.sizeOf(context).width * 1.0,
                    height: 150.0,
                    constraints: const BoxConstraints(
                      maxHeight: 200.0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).primary,
                          const Color(0x0039D2C0)
                        ],
                        stops: const [0.0, 1.0],
                        begin: const AlignmentDirectional(0.0, -1.0),
                        end: const AlignmentDirectional(0, 1.0),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                          10.0, 0.0, 10.0, 0.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0.0, 30.0, 0.0, 0.0),
                            child: Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.arrow_back,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    HapticFeedback.lightImpact();
                                    context.safePop();
                                  },
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    valueOrDefault<String>(
                                      widget.user,
                                      'Full Name',
                                    ),
                                    textAlign: TextAlign.center,
                                    style: FlutterFlowTheme.of(context)
                                        .titleSmall
                                        .override(
                                      font: GoogleFonts.interTight(
                                        fontWeight: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontWeight,
                                        fontStyle: FlutterFlowTheme.of(context)
                                            .titleSmall
                                            .fontStyle,
                                      ),
                                      color: FlutterFlowTheme.of(context).info,
                                      fontSize: 18.0,
                                      letterSpacing: 0.0,
                                      fontWeight: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontWeight,
                                      fontStyle: FlutterFlowTheme.of(context)
                                          .titleSmall
                                          .fontStyle,
                                      shadows: [
                                        Shadow(
                                          color: FlutterFlowTheme.of(context)
                                              .secondaryText,
                                          offset: const Offset(2.0, 2.0),
                                          blurRadius: 15.0,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                FlutterFlowIconButton(
                                  borderRadius: 8.0,
                                  buttonSize: 40.0,
                                  icon: Icon(
                                    Icons.person_rounded,
                                    color: FlutterFlowTheme.of(context).info,
                                    size: 24.0,
                                  ),
                                  onPressed: () async {
                                    HapticFeedback.lightImpact();
                                    context.safePop();
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]
                            .addToStart(const SizedBox(height: 20.0))
                            .addToEnd(const SizedBox(height: 20.0)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Message input row
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(
                  10.0, 5.0, 10.0, 35.0),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Expanded(
                    child: SizedBox(
                      width: 200.0,
                      child: TextFormField(
                        controller: _model.messageBodyFieldTextController,
                        focusNode: _model.messageBodyFieldFocusNode,
                        onFieldSubmitted: (_) async {
                          HapticFeedback.lightImpact();
                          await _sendMessage();
                        },
                        autofocus: false,
                        enabled: !_isSending,
                        textCapitalization: TextCapitalization.sentences,
                        obscureText: false,
                        decoration: InputDecoration(
                          isDense: false,
                          labelStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                          hintText: 'Send a Message...',
                          hintStyle: FlutterFlowTheme.of(context)
                              .labelMedium
                              .override(
                                font: GoogleFonts.inter(
                                  fontWeight: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontWeight,
                                  fontStyle: FlutterFlowTheme.of(context)
                                      .labelMedium
                                      .fontStyle,
                                ),
                                letterSpacing: 0.0,
                                fontWeight: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .labelMedium
                                    .fontStyle,
                              ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                              color: Color(0x00000000),
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: FlutterFlowTheme.of(context).error,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          filled: true,
                          fillColor: FlutterFlowTheme.of(context)
                              .secondaryBackground,
                        ),
                        style: FlutterFlowTheme.of(context).bodyMedium.override(
                              font: GoogleFonts.inter(
                                fontWeight: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontWeight,
                                fontStyle: FlutterFlowTheme.of(context)
                                    .bodyMedium
                                    .fontStyle,
                              ),
                              letterSpacing: 0.0,
                              fontWeight: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontWeight,
                              fontStyle: FlutterFlowTheme.of(context)
                                  .bodyMedium
                                  .fontStyle,
                            ),
                        maxLines: null,
                        cursorColor: FlutterFlowTheme.of(context).primaryText,
                        enableInteractiveSelection: true,
                        validator: _model
                            .messageBodyFieldTextControllerValidator
                            .asValidator(context),
                        inputFormatters: [
                          if (!isAndroid && !isiOS)
                            TextInputFormatter.withFunction(
                                (oldValue, newValue) {
                              return TextEditingValue(
                                selection: newValue.selection,
                                text: newValue.text.toCapitalization(
                                    TextCapitalization.sentences),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                  FlutterFlowIconButton(
                    borderRadius: 8.0,
                    buttonSize: 40.0,
                    fillColor: FlutterFlowTheme.of(context).primaryBackground,
                    showLoadingIndicator: _isSending,
                    icon: Icon(
                      Icons.send_rounded,
                      color: FlutterFlowTheme.of(context).primary,
                      size: 24.0,
                    ),
                    onPressed: _isSending
                        ? null
                        : () async {
                            HapticFeedback.lightImpact();
                            await _sendMessage();
                          },
                  ),
                ].divide(const SizedBox(width: 10.0)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
