LOCAL_PATH:= $(call my-dir)
include $(CLEAR_VARS)

# measurements show that the ARM version of ZLib is about x1.17 faster
# than the thumb one...
LOCAL_ARM_MODE := arm

zlib_files := \
	src/adler32.c \
	src/compress.c \
	src/crc32.c \
	src/deflate.c \
	src/gzclose.c \
	src/gzlib.c \
	src/gzread.c \
	src/gzwrite.c \
	src/inftrees.c \
	src/trees.c \
	src/uncompr.c \
	src/zutil.c \
	src/contrib/optimizations/inffast_chunky.c \
	src/contrib/optimizations/inflate.c \
	src/contrib/optimizations/arm/arm_features.c \
	src/contrib/optimizations/arm/armv8_crc32.c \
	src/contrib/optimizations/arm/infback.c

zlib_cflags := -O3 -funroll-loops -DUSE_MMAP -DZLIB_CONST -DUNALIGNED_OK

LOCAL_MODULE := libz
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS += $(zlib_cflags)
LOCAL_SDCLANG_LTO := true

# TODO: This is to work around b/24465209. Remove after root cause is fixed
LOCAL_LDFLAGS_arm := -Wl,--hash-style=both

LOCAL_SRC_FILES := $(zlib_files)
ifneq ($(TARGET_BUILD_APPS),)
  LOCAL_SDK_VERSION := 9
else
  LOCAL_CXX_STL := none
endif
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH) \
				src/contrib/optimizations \
				src/contrib/optimizations/arm
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_ARM_MODE := arm
LOCAL_MODULE := libz
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS += $(zlib_cflags)
LOCAL_SDCLANG_LTO := true
LOCAL_SRC_FILES := $(zlib_files)
ifneq ($(TARGET_BUILD_APPS),)
  LOCAL_SDK_VERSION := 9
else
  LOCAL_CXX_STL := none
endif
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)
include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := libz
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS += $(zlib_cflags)
LOCAL_SRC_FILES := $(zlib_files)
LOCAL_MULTILIB := both
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)
LOCAL_MODULE_HOST_OS := darwin linux windows
LOCAL_CXX_STL := none
include $(BUILD_HOST_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE := libz-host
LOCAL_MODULE_TAGS := optional
LOCAL_CFLAGS += $(zlib_cflags)
LOCAL_SRC_FILES := $(zlib_files)
LOCAL_MULTILIB := both
LOCAL_EXPORT_C_INCLUDE_DIRS := $(LOCAL_PATH)
LOCAL_CXX_STL := none
include $(BUILD_HOST_SHARED_LIBRARY)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:=        \
	src/test/minigzip.c

LOCAL_MODULE:= gzip

LOCAL_SHARED_LIBRARIES := libz

LOCAL_CXX_STL := none

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:=        \
	src/test/minigzip.c

LOCAL_MODULE:= minigzip

LOCAL_STATIC_LIBRARIES := libz

LOCAL_CXX_STL := none

include $(BUILD_HOST_EXECUTABLE)

# Unset local variables
zlib_files:=
zlib_cflags:=
