LOCAL_PATH := $(call my-dir)
include $(LOCAL_PATH)/../common.mk
include $(CLEAR_VARS)
LOCAL_HEADER_LIBRARIES += $(common_header_libraries)

LOCAL_MODULE                  := libqdutils
LOCAL_MODULE_TAGS             := optional
LOCAL_VENDOR_MODULE           := true
LOCAL_USE_VNDK                := true
# NOTE: libqdutils is an SP-HAL dependency (gralloc -> libmemalloc -> libqdutils),
# loaded into system processes (surfaceflinger/apps) via the "sphal" namespace,
# which only links VNDK-SP + LLNDK. Any full-VNDK lib (libui, libgui, libbinder)
# is unreachable there, so libqdutils must stay free of all of them.
#  - libui came from cb_utils/cb_swap_rect (copybit wormhole Region) -> moved to
#    libhwcomposer (composer service = vendor default ns, where libui IS available).
#  - libbinder/libqservice came from display_config.cpp (IQService client) -> moved
#    to libhwcomposer too (its only caller is hwc_qclient/hwc.cpp). libmemalloc only
#    needs MDPVersion/QCCompositionType from here, never display_config.
# Both moves keep libqdutils binder-/libui-free so gralloc loads in sphal.
LOCAL_SHARED_LIBRARIES        := $(common_libs)
LOCAL_C_INCLUDES              := $(common_includes) $(kernel_includes)
LOCAL_CFLAGS                  := $(common_flags) -DLOG_TAG=\"qdutils\" -Wno-float-conversion
LOCAL_ADDITIONAL_DEPENDENCIES := $(common_deps)
LOCAL_COPY_HEADERS_TO         := $(common_header_export_path)
LOCAL_COPY_HEADERS            := display_config.h mdp_version.h
LOCAL_SRC_FILES               := profiler.cpp mdp_version.cpp \
                                 idle_invalidator.cpp \
                                 comptype.cpp qd_utils.cpp
include $(BUILD_SHARED_LIBRARY)

include $(CLEAR_VARS)
LOCAL_HEADER_LIBRARIES += $(common_header_libraries)

LOCAL_COPY_HEADERS_TO           := $(common_header_export_path)
LOCAL_COPY_HEADERS              := qdMetaData.h qd_utils.h
LOCAL_SHARED_LIBRARIES          := liblog libcutils
LOCAL_C_INCLUDES                := $(common_includes)
LOCAL_ADDITIONAL_DEPENDENCIES   := $(common_deps)
LOCAL_SRC_FILES                 := qdMetaData.cpp qd_utils.cpp
LOCAL_CFLAGS                    := $(common_flags)
LOCAL_CFLAGS                    += -DLOG_TAG=\"DisplayMetaData\"
LOCAL_MODULE_TAGS               := optional
LOCAL_MODULE                    := libqdMetaData
LOCAL_VENDOR_MODULE             := true
LOCAL_USE_VNDK                  := true
include $(BUILD_SHARED_LIBRARY)


include $(CLEAR_VARS)
LOCAL_HEADER_LIBRARIES += $(common_header_libraries)

LOCAL_SHARED_LIBRARIES          := liblog libcutils
LOCAL_C_INCLUDES                := $(common_includes)
LOCAL_ADDITIONAL_DEPENDENCIES   := $(common_deps)
LOCAL_SRC_FILES                 := qdMetaData.cpp qd_utils.cpp
LOCAL_CFLAGS                    := $(common_flags) -Wno-sign-conversion
LOCAL_CFLAGS                    += -DLOG_TAG=\"DisplayMetaData\"

LOCAL_MODULE_TAGS               := optional
LOCAL_MODULE                    := libqdMetaData.system

include $(BUILD_SHARED_LIBRARY)
