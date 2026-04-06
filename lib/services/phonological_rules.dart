import 'dart:ffi';
import 'dart:developer';
import 'dart:io';

import 'package:ffi/ffi.dart';

const _libPath = 'assets/libph_lib.so';

final class ResultRuleNative extends Struct {
  @Uint8()
  external int isError;

  external Pointer<Opaque> rule;
}

final class ResultNative extends Struct {
  @Uint8()
  external int isError;

  external Pointer<Utf8> result;
}

class PhonologicalRules {
  final DynamicLibrary _lib;

  late final Pointer<Utf8> Function() _versionFn;
  late final Pointer<Utf8> Function(Pointer<Utf8>) _distinctiveFeaturesFn;
  late final Pointer<ResultRuleNative> Function(Pointer<Utf8>) _createRuleFn;
  late final void Function(Pointer<ResultRuleNative>) _destroyRuleFn;
  late final Pointer<ResultNative> Function(Pointer<Utf8>, Pointer<Opaque>) _applyRuleFn;
  late final void Function(Pointer<ResultNative>) _destroyRuleResultFn;

  PhonologicalRules() : _lib = _loadLib() {
    log('PhonologicalRules: initializing and binding native functions');
    _versionFn = _lib.lookupFunction<Pointer<Utf8> Function(), Pointer<Utf8> Function()>('version');
    _distinctiveFeaturesFn = _lib
        .lookupFunction<Pointer<Utf8> Function(Pointer<Utf8>), Pointer<Utf8> Function(Pointer<Utf8>)>(
          'distinctiveFeatures',
        );
    _createRuleFn = _lib
        .lookupFunction<
          Pointer<ResultRuleNative> Function(Pointer<Utf8>),
          Pointer<ResultRuleNative> Function(Pointer<Utf8>)
        >('createRule');
    _destroyRuleFn = _lib
        .lookupFunction<Void Function(Pointer<ResultRuleNative>), void Function(Pointer<ResultRuleNative>)>(
          'destroyRule',
        );
    _applyRuleFn = _lib
        .lookupFunction<
          Pointer<ResultNative> Function(Pointer<Utf8>, Pointer<Opaque>),
          Pointer<ResultNative> Function(Pointer<Utf8>, Pointer<Opaque>)
        >('applyRule');
    _destroyRuleResultFn = _lib
        .lookupFunction<Void Function(Pointer<ResultNative>), void Function(Pointer<ResultNative>)>(
          'destroyRuleResult',
        );
  }

  static DynamicLibrary _loadLib() {
    if (Platform.isLinux) {
      return DynamicLibrary.open(_libPath);
    }
    throw UnsupportedError('Platform not supported');
  }

  String version() => _versionFn().toDartString();

  String distinctiveFeatures(String input) {
    log('PhonologicalRules.distinctiveFeatures: input="$input"');
    final cStr = input.toNativeUtf8();
    try {
      final ptr = _distinctiveFeaturesFn(cStr);
      final output = ptr.toDartString();
      log('PhonologicalRules.distinctiveFeatures: success output="$output"');
      return output;
    } finally {
      malloc.free(cStr);
      log('PhonologicalRules.distinctiveFeatures: freed input pointer');
    }
  }

  PhonologicalRulesApplyResult applyRule(String rule, String input) {
    log('PhonologicalRules.applyRule: start rule="$rule" input="$input"');

    final cRule = rule.toNativeUtf8();
    late final Pointer<ResultRuleNative> ruleResult;
    var hasRuleResult = false;
    try {
      log('PhonologicalRules.applyRule: calling native createRule');
      ruleResult = _createRuleFn(cRule);
      log('PhonologicalRules.applyRule: called native createRule ${ruleResult.ref}');
      hasRuleResult = true;
      if (ruleResult.ref.isError != 0) {
        log('PhonologicalRules.applyRule: createRule error');
        return const PhonologicalRulesApplyResult.error('Rule error');
      }
      if (ruleResult.ref.rule == nullptr) {
        log('PhonologicalRules.applyRule: createRule nullptr');
        return const PhonologicalRulesApplyResult.error('Rule error');
      }
    } finally {
      malloc.free(cRule);
      log('PhonologicalRules.applyRule: freed rule input pointer');
    }

    final cInput = input.toNativeUtf8();
    late final Pointer<ResultNative> applyResult;
    var hasApplyResult = false;
    try {
      log('PhonologicalRules.applyRule: calling native applyRule');
      applyResult = _applyRuleFn(cInput, ruleResult.ref.rule);
      hasApplyResult = true;
      if (applyResult.ref.isError != 0 || applyResult.ref.result == nullptr) {
        log('PhonologicalRules.applyRule: applyRule failed');
        return const PhonologicalRulesApplyResult.error('Apply error');
      }
      final output = applyResult.ref.result.toDartString();
      log('PhonologicalRules.applyRule: success output="$output"');
      return PhonologicalRulesApplyResult.success(output);
    } finally {
      if (hasApplyResult) {
        _destroyRuleResultFn(applyResult);
        log('PhonologicalRules.applyRule: destroyed native apply result');
      }
      malloc.free(cInput);
      log('PhonologicalRules.applyRule: freed apply input pointer');
      if (hasRuleResult) {
        _destroyRuleFn(ruleResult);
        log('PhonologicalRules.applyRule: destroyed native rule result');
      }
    }
  }

  bool validateRule(String rule) {
    final cRule = rule.toNativeUtf8();
    late final Pointer<ResultRuleNative> ruleResult;
    var hasRuleResult = false;
    try {
      ruleResult = _createRuleFn(cRule);
      hasRuleResult = true;
      if (ruleResult.ref.isError != 0) {
        return false;
      }
      return ruleResult.ref.rule != nullptr;
    } catch (_) {
      return false;
    } finally {
      malloc.free(cRule);
      if (hasRuleResult) {
        _destroyRuleFn(ruleResult);
      }
    }
  }
}

class PhonologicalRulesApplyResult {
  final String? value;
  final String? error;

  const PhonologicalRulesApplyResult._({this.value, this.error});

  const PhonologicalRulesApplyResult.success(String value) : this._(value: value);

  const PhonologicalRulesApplyResult.error(String error) : this._(error: error);

  bool get isError => error != null;
}
