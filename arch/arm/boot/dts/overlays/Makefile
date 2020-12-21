# Overlays for the BeagleBone platform

dtbo-$(CONFIG_SOC_AM33XX) += \
	srg52-extension-a.dtbo \
	srg52-extension-b.dtbo

targets += dtbs dtbs_install
targets += $(dtbo-y)

always		:= $(dtbo-y)
clean-files	:= *.dtbo
