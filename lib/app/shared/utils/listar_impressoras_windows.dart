// import 'dart:convert';
// import 'dart:ffi' as ffi;

// typedef CEnumPrinters = ffi.Int32 Function(
//   ffi.Int32 flags,
//   ffi.Pointer<ffi.Uint8> name,
//   ffi.Int32 level,
//   ffi.Pointer<ffi.Uint8> printerEnum,
//   ffi.Int32 buf,
//   ffi.Pointer<ffi.Int32> needed,
//   ffi.Pointer<ffi.Int32> returned,
// );

// typedef EnumPrinters = int Function(
//   int flags,
//   ffi.Pointer<ffi.Uint8> name,
//   int level,
//   ffi.Pointer<ffi.Uint8> printerEnum,
//   int buf,
//   ffi.Pointer<ffi.Int32> needed,
//   ffi.Pointer<ffi.Int32> returned,
// );

// // Example of handling a simple C struct
// class PrintInfo extends ffi.Struct {
//   @ffi.Int32()
//   int flags;

//   @ffi.Uint64()
//   int _description;

//   @ffi.Uint64()
//   int _name;

//   @ffi.Uint64()
//   int _comment;

//   String _utf16ToString(int address) {
//     final ptr = ffi.Pointer<ffi.Uint16>.fromAddress(address);
//     final units = List<int>();
//     var len = 0;
//     while (true) {
//       final char = ptr.elementAt(len++).load<int>();
//       if (char == 0) break;
//       units.add(char);
//     }
//     return Utf8Decoder().convert(units);
//   }

//   String get description => _utf16ToString(_description);

//   String get name => _utf16ToString(_name);

//   String get comment => _utf16ToString(_comment);

//   @override
//   String toString() =>
//       '$runtimeType\n  Flags=$flags\n  Name=$name\n  Description=$description\n  Comment=$comment';
// }

// void main() {
//   final dylib = ffi.DynamicLibrary.open('winspool.drv');
//   final enumPrintersPointer =
//       dylib.lookup<ffi.NativeFunction<CEnumPrinters>>('EnumPrintersW');
//   final enumPrinters = enumPrintersPointer.asFunction<EnumPrinters>();

//   final needed = ffi.Pointer<ffi.Int32>.allocate()..store(0);
//   final returned = ffi.Pointer<ffi.Int32>.allocate()..store(0);
//   enumPrinters(2, ffi.Pointer.fromAddress(0), 1, ffi.Pointer.fromAddress(0), 0,
//       needed, returned);

//   final bufferSize = needed.load<int>();
//   final buffer = ffi.Pointer<ffi.Uint8>.allocate(count: bufferSize);
//   final result = enumPrinters(
//       2, ffi.Pointer.fromAddress(0), 1, buffer, bufferSize, needed, returned);

//   if (result == 0) throw ('Error listing the printers');

//   final count = returned.load<int>();

//   final a = ffi.Pointer<PrintInfo>.fromAddress(buffer.address);
//   for (int i = 0; i < count; i++) {
//     print(a.elementAt(i).load<PrintInfo>());
//   }

//   buffer.free();
// }
