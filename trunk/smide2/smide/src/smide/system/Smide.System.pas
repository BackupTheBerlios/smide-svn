unit Smide.System;

interface

uses
  Smide.System.Runtime,
  Smide.System.Runtime.Reference,
  Smide.System.Runtime.Environment,
  Smide.System.Common,
  Smide.System.Common.Number,
  Smide.System.Common.Strings,
  Smide.System.Types,
  Smide.System.Reflection.Runtime.Handles,
  Smide.System.Runtime.Exceptions;

type
  TSmideObject = Smide.System.Runtime.TSmideObject;

  // Exceptions
  Exception = Smide.System.Common.Exception;
  ESystem = Smide.System.Common.ESystem;
  EStaticAccess = Smide.System.Common.EStaticAccess;
  ENotImplemented = Smide.System.Common.ENotImplemented;
  EArgument = Smide.System.Common.EArgument;
  EArgumentNil = Smide.System.Common.EArgumentNil;
  EArgumentEmpty = Smide.System.Common.EArgumentEmpty;
  EArgumentOutOfRange = Smide.System.Common.EArgumentOutOfRange;
  EInvalidOperation = Smide.System.Common.EInvalidOperation;
  EUnknownType = Smide.System.Common.EUnknownType;
  ENotSupported = Smide.System.Common.ENotSupported;
  ENoClassInfo = Smide.System.Common.ENoClassInfo;
  ETarget = Smide.System.Common.ETarget;

  // Runtime Exceptions
  EOsError = Smide.System.Runtime.Exceptions.EOsError;

  // Statics
  TStaticBase = Smide.System.Common.TStaticBase;

  // Reference support
  TReference = Smide.System.Runtime.Reference.TReference;

  // RuntimeHandles
  TRuntimeFieldHandle = Smide.System.Reflection.Runtime.Handles.TRuntimeFieldHandle;
  TRuntimeMethodHandle = Smide.System.Reflection.Runtime.Handles.TRuntimeMethodHandle;
  TRuntimeTypeHandle = Smide.System.Reflection.Runtime.Handles.TRuntimeTypeHandle;

  // Types
  TType = Smide.System.Types.TType;
  ITypeHandler = Smide.System.Types.ITypeHandler;
  TTypeData = Smide.System.Types.TTypeData;

  // Environment support
  TEnvironment = Smide.System.Runtime.Environment.TEnvironment;

  // Numbers
  TNumber = Smide.System.Common.Number.TNumber;

  // Strings

  TString = Smide.System.Common.Strings.TString;

implementation

end.

