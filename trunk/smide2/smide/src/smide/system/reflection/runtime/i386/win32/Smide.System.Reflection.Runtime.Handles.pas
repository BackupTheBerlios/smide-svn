unit Smide.System.Reflection.Runtime.Handles;

interface

uses
  Smide.System.Types.Runtime.TypeInfo;

type
  TRuntimeFieldHandle = type Pointer;
  TRuntimeMethodHandle = type Pointer;

  TRuntimeTypeHandle = PTypeInfo;
  TRuntimeTypeInfoData = PTypeInfoData;

implementation

end.
