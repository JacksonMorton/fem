#define NODIALS    1
#define NOGL       1
#define NOOGL      1
#define NOMOTIF    1
#define NOPEX      1
#define NOPHIGS    1
#define HIGHFIRST
#define ORDER_ABCD 

#ifdef  AUTODOUBLE
#define FortranMindex  long long
#define FortranInteger long long
#define FortranReal    double
#define FortranDouble  double
#else
#define FortranMindex  long
#define FortranInteger int
#define FortranReal    float
#define FortranDouble  double
#endif

#ifdef  ALPHA
#define UNSCORE 1
#undef  ORDER_ABCD
#define ORDER_DCBA 
#define C_LITTLE_ENDIAN
#endif

#ifdef  FJVPP
#define UNSCORE 1
#endif

#if defined SR8000 || defined EP8000
#define UPCASE 1
#ifdef  AUTODOUBLE
#ifndef ADDR64
#undef  FortranMindex
#define FortranMindex long
#endif
#endif
#endif

#ifdef  HPUX11
#define HPUX
#endif

#ifdef  HPUX
#ifdef  AUTODOUBLE
#ifndef ADDR64
#undef  FortranMindex
#define FortranMindex long
#endif
#endif
#endif

#ifdef  IBMAIX
#ifdef  AUTODOUBLE
#ifndef ADDR64
#undef  FortranMindex
#define FortranMindex long
#endif
#endif
#endif

#if defined (SGI32) || defined (SGI64) || defined (SGI53)
#ifndef SGI
#define SGI
#endif
#define UNSCORE 1
#endif

#ifdef  SUN
#define SPARC
#define UNSCORE 1

#ifdef  V9
#undef  FortranMindex
#define FortranMindex  long
#endif

#endif

#ifdef  FJPP
#define SPARC
#define UNSCORE 1
#ifdef  AUTODOUBLE
#ifndef ADDR64
#undef  FortranMindex
#define FortranMindex long
#endif
#endif
#else
#ifdef  ADDR64
#undef  FortranMindex
#define FortranMindex long
#endif
#endif

#ifdef  CRAYT3E
#undef  CRAY
#define UPCASE 1
#undef  FortranReal
#define FortranReal    double
#endif

#if defined  CRAY && !defined CRAYSV2_32 && !defined CRAYSV2_64
#define UPCASE 1
#undef  FortranDouble
#define FortranDouble  float
#endif

#if defined CRAYSV2_32
#define UNSCORE 1
#undef  FortranMindex
#undef  FortranInteger
#undef  FortranReal
#undef  FortranDouble
#define FortranMindex long
#define FortranInteger int
#define FortranReal float
#define FortranDouble double
#endif

#if defined CRAYSV2_64
#define UNSCORE 1
#undef  FortranMindex
#undef  FortranInteger
#undef  FortranReal
#undef  FortranDouble
#define FortranMindex long
#define FortranInteger long
#define FortranReal double
#define FortranDouble double
#define ADDR64
#endif

#ifdef  NEC
#define UNSCORE 1
#endif

#ifdef  LINUX
#if defined ALPHA && defined MPP
#define C_LITTLE_ENDIAN
#else
#define UNSCORE 1
#undef  ORDER_ABCD
#define ORDER_DCBA
#endif
#ifdef  AUTODOUBLE
#undef  FortranMindex
#define FortranMindex long
#endif
#endif

/* Fortran calling convention - only used in MSVC */
#define FORTRAN_CC

#if defined  (MPPWIN) || defined (PCWIN)
#if defined (PCWIN)
#undef  FORTRAN_CC
#define FORTRAN_CC __stdcall
#endif
#undef  ORDER_ABCD
#define ORDER_DCBA
#ifndef MSTI
#define UPCASE 1
#endif
#ifdef  AUTODOUBLE
#undef  FortranMindex
#define FortranMindex long
#undef  FortranInteger
#define FortranInteger __int64
#endif
#endif

#ifdef  IA64
#define ADDR64
#define UNSCORE 1
#undef  ORDER_ABCD
#define ORDER_DCBA
#undef  FortranMindex
#define FortranMindex  long
#endif
