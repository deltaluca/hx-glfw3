package glfw3;

import haxe.macro.Context;
import haxe.macro.Expr;


@:autoBuild(glfw3.GLProcsImpl.run())
@:remove extern interface GLProcs {}


//
// @:GLProc function x(...) {
//    ...
// }
//
// replaced by
//
// public static inline function x(...) {
//    #if debug
//        if ($param0 == null) throw "x :: $param0 cannot be null";
//    #end
//    ...
// }
//
// for any parameter marked non-optional, and of non-basic type.
//
// to override/add additional checks use:
// {
//    @:GLCheck(?paramName) if (cond) throw "message"
//    ...
// }
// with any default check on parameter disregarded
// and the message prepended by "x :: "
//
class GLProcsImpl {
#if macro
    static function isProc(f:Metadata) {
        for (m in f) {
            if (m.name == ":GLProc") return true;
        }
        return false;
    }

    static function skippedType(t:ComplexType):Bool {
        return switch(t) {
        case macro :Int: true;
        case macro :Float: true;
        case macro :Bool: true;
        case macro :Dynamic: true;
        case TPath({name:"Null"}): true;
        default: false;
        }
    }

    // e:Null<T> => (e:T => *)
    // e:Int, Float, String, Bool => e
    // e:Point => NativeBinding.native(e)
    // e:Array<Int,Float,String,Bool> => e
    // e:Array<Point> => NativeBinding.mapNative(e)
    static function transformArg(e:Expr, t:ComplexType):Null<Expr> {
        function targ(e:Expr, t:ComplexType) {
            return switch(t) {
            case TPath({name:"Null",params:[TPType(t)]}): targ(e, t);
            case macro :Int: null;
            case macro :Float: null;
            case macro :String: null;
            case macro :Bool: null;
            case TFunction(_,_): null;
            case TPath({name:"Array",params:[TPType(t)]}):
                var e2 = targ(e, t);
                if (e2 == null || switch (t) {
                    case TPath({name:"T"}): true;
                    default: false;
                }) e;
                else macro NativeBinding.mapNative($e);
            default: macro NativeBinding.native($e);
            }
        }

        var e2 = targ(e, t);
        if (e2 == null) e2 = e;
        return e2;
    }

    static function typeToIdent(t:ComplexType):Expr {
        return macro $p{haxe.macro.ComplexTypeTools.toString(t).split(".")};
    }

    static function transformRet(e:Expr, t:ComplexType):Null<Expr> {
        switch (t) {
            case macro :Void: return e;
            default:
        }

        function tret(e:Expr, t:ComplexType) {
            return switch(t) {
            case TPath({name:"Null",params:[TPType(t)]}): tret(e, t);
            case macro :Int: null;
            case macro :Float: null;
            case macro :String: null;
            case macro :Bool: null;
            case TFunction(_,_): null;
            case TPath({name:"Array",params:[TPType(_)]}):
                Context.error("@:GLProc doesn't know how to handle generating body of Array returned methods", e.pos);
                null;
            case TPath(_):
                macro $e{typeToIdent(t)}.cvt($e);
            default:
                Context.error("@:GLProc doesn't know hot to handle generating body with this return type", e.pos);
                null;
            };
        }

        var e2 = tret(e, t);
        if (e2 == null) e2 = e;
        return macro return $e2;
    }

    static function params(f:Field):Array<Expr> {
        for (m in f.meta) {
            if (m.name == ":GLProc") {
                return m.params;
            }
        }
        return [];
    }
    static function paramName(f:Field):Null<Expr> {
        for (p in params(f)) {
            switch (p.expr) {
            case EConst(CIdent(n)):
                p.expr = EConst(CString(n));
                return p;
            default:
            }
        }
        return null;
    }

    static var printer:haxe.macro.Printer;
    static function process(field:Field, f:Function) {
        if (printer == null) printer = new haxe.macro.Printer();
        var skipped = new Map<String,Bool>();

        // process manual checks
        if (f.expr == null) {
            var build = if (f.ret != null) function (e:Expr) return macro return $e; else function (e:Expr) return e;
            var args = [];
            for (i in f.args) {
                var e2 = transformArg(macro $i{i.name}, i.type);
                args.push(e2);
            }

            var name = paramName(field);
            if (name == null) name = macro $v{field.name};

            f.expr = macro load($name, $v{f.args.length})($a{args});

            if (f.ret != null) {
                f.expr = transformRet(f.expr, f.ret);
            }
/*
            if (f.ret == null || switch (f.ret) {
                case macro :Void: true;
                default: false;
            })
                f.expr = macro {
                    ${if (Context.defined("cpp")) macro cpp.vm.Gc.enterGCFreeZone() else macro {}};
                    ${f.expr};
                    ${if (Context.defined("cpp")) macro cpp.vm.Gc.exitGCFreeZone() else macro {}};
                };
            else
                f.expr = macro {
                    ${if (Context.defined("cpp")) macro cpp.vm.Gc.enterGCFreeZone() else macro {}};
                    var ret = (function () ${f.expr})();
                    ${if (Context.defined("cpp")) macro cpp.vm.Gc.exitGCFreeZone() else macro {}};
                    return ret;
                };*/
        }
        else {
            f.expr.expr = switch (f.expr.expr) {
            case EBlock(xs):
                var ys = [];
                for (x in xs) {
                    switch (x.expr) {
                    case EMeta({name:":GLCheck", params:params, pos:p}, y):
                        if (!Context.defined("debug") || true) continue;
                        if (params.length > 1) {
                            for (n in params) {
                                skipped.set(switch (n.expr) {
                                    case EConst(CIdent(n)): n;
                                    default:
                                        Context.warning("@:GLCheck param should be identifier name", p);
                                        null;
                                }, true);
                            }
                        }
                        switch (y) {
                        case (macro if ($cond) throw $err else $e) if (e == null):
                            var err2 = '${field.name} :: ';
                            ys.push(macro if ($cond) throw $v{err2}+$err);
                        default:
                            Context.warning("@:GLCheck expr was not if (..) throw ..", p);
                        }
                    default: ys.push(x);
                    }
                }
                EBlock(ys);
            default:
                f.expr.expr;
            }
        }

        var checks = [];
        if (Context.defined("debug") && false) {
            for (arg in f.args) {
                if (arg.type == null) Context.warning("@:GLProc should have arg types declared", field.pos);
                if (arg.opt || skippedType(arg.type)) continue;

                if (skipped.get(arg.name)) continue;

                var err = '${field.name} :: ${arg.name} cannot be null';
                checks.push(macro
                    if ($i{arg.name} == null) throw $v{err}
                );
            }
            f.expr = macro { $b{checks}; $e{f.expr} };
        }

        for (p in params(field)) {
            switch (p) {
            case macro $n=$v:
                f.expr = macro {
                    if ($n == null) $n = $v;
                    $e{f.expr};
                };
            default:
            }
        }

        field.access.push(AStatic);
        field.access.push(APublic);
        field.access.push(AInline);
    }

    static function run() {
        var fields = Context.getBuildFields();

        for (f in fields) {
            if (!isProc(f.meta)) continue;

            switch (f.kind) {
            case FFun(g):
                process(f, g);
            default:
                Context.warning("@:GLProc used on non-method type", f.pos);
            }
        }
        return fields;
    }
#end
}


//
// Add same type vector operations
// for GL vector type.
//
class GLVector {
#if macro
    static var N:Int;
    static var fields:Array<Field>;
    static var selfT:ComplexType;

    static function unop(name:String, op:Unop, post:Bool) {
        var es = [];
        for (i in 0...N) {
            es.push({
                pos: Context.currentPos(),
                expr: EUnop(op, post, macro u[$v{i}])
            });
        }
        fields.push({
            pos: Context.currentPos(),
            name: name,
            meta: [{
                pos: Context.currentPos(),
                name: ":op",
                params: [{
                    expr: EUnop(op, post, macro A),
                    pos: Context.currentPos()
                }]
            }],
            kind: FFun({
                ret: selfT,
                params: [],
                args: [{
                    value: null,
                    type: selfT,
                    opt: false,
                    name: "u",
                }],
                expr: macro return $a{es}
            }),
            doc: null,
            access: [AInline, AStatic, APublic]
        });
    }

    static function binop(name:String, op:Binop, self:Bool=false) {
        var es = [];
        for (i in 0...N) {
            es.push({
                pos: Context.currentPos(),
                expr: EBinop(op, macro u[$v{i}], macro v[$v{i}])
            });
        }
        fields.push({
            pos: Context.currentPos(),
            name: name,
            meta: [{
                pos: Context.currentPos(),
                name: ":op",
                params: [{
                    expr: EBinop(op, macro A, macro B),
                    pos: Context.currentPos()
                }]
            }],
            kind: FFun({
                ret: selfT,
                params: [],
                args: [{
                    value: null,
                    type: selfT,
                    opt: false,
                    name: "u",
                }, {
                    value: null,
                    type: selfT,
                    opt: false,
                    name: "v",
                }],
                expr: self ? macro { $b{es}; return u; } : macro return $a{es}
            }),
            doc: null,
            access: [AInline, AStatic, APublic]
        });

        var es = [];
        for (i in 0...N) {
            es.push({
                pos: Context.currentPos(),
                expr: EBinop(op, macro u[$v{i}], macro v)
            });
        }
        fields.push({
            pos: Context.currentPos(),
            name: name+"f",
            meta: [{
                pos: Context.currentPos(),
                name: ":op",
                params: [{
                    expr: EBinop(op, macro A, macro B),
                    pos: Context.currentPos()
                }]
            }],
            kind: FFun({
                ret: selfT,
                params: [],
                args: [{
                    value: null,
                    type: selfT,
                    opt: false,
                    name: "u",
                }, {
                    value: null,
                    type: macro :Float,
                    opt: false,
                    name: "v",
                }],
                expr: self ? macro { $b{es}; return u; } : macro return $a{es}
            }),
            doc: null,
            access: [AInline, AStatic, APublic]
        });
        fields.push({
            pos: Context.currentPos(),
            name: name+"i",
            meta: [{
                pos: Context.currentPos(),
                name: ":op",
                params: [{
                    expr: EBinop(op, macro A, macro B),
                    pos: Context.currentPos()
                }]
            }],
            kind: FFun({
                ret: selfT,
                params: [],
                args: [{
                    value: null,
                    type: selfT,
                    opt: false,
                    name: "u",
                }, {
                    value: null,
                    type: macro :Int,
                    opt: false,
                    name: "v",
                }],
                expr: self ? macro { $b{es}; return u; } : macro return $a{es}
            }),
            doc: null,
            access: [AInline, AStatic, APublic]
        });
    }

    public static function run(n:Int) {
        N = n;
        fields = Context.getBuildFields();

        selfT = TPath({sub:null,params:[],pack:[],name:"Vec"+N});

        binop("add", OpAdd);
        binop("sub", OpSub);
        binop("div", OpDiv);
        binop("mul", OpMult);

        binop("assign", OpAssign, true);
        binop("addAssign", OpAssignOp(OpAdd), true);
        binop("subAssign", OpAssignOp(OpSub), true);
        binop("divAssign", OpAssignOp(OpDiv), true);
        binop("mulAssign", OpAssignOp(OpMult), true);

        unop("neg", OpNeg, false);

        return fields;
    }
#end
}
