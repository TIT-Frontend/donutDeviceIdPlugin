// pages/ios/ios.js
const { miniAppPluginId } = require('../../constant');

Page({

  /**
   * 页面的初始数据
   */
  data: {
    myPlugin: undefined,
    quickStartContents: [
      '在「设置」->「安全设置」中手动开启多端插件服务端口',
      '在「工具栏」->「运行设备」中选择 iOS 点击「运行」，快速准备运行环境',
      '在打开的 Xcode 中点击「播放」运行原生工程',
      '保持开发者工具开启，修改小程序代码和原生代码仅需在 Xcode 中点击「播放」查看效果',
    ]
  },

  onLoadPlugin() {
    wx.miniapp.loadNativePlugin({
      pluginId: miniAppPluginId,
      success: (plugin) => {
        console.log('load plugin success', plugin)
        this.setData({
          myPlugin: plugin
        })
      },
      fail: (e) => {
        console.log('load plugin fail', e)
      }
    })
  },

  onUsePlugin() {
    const { myPlugin } = this.data
    if (!myPlugin) {
      console.log('plugin is undefined')
      return
		}

		myPlugin.requestTrackingPermission({}, (ret) => {
			console.log(' ret:', ret)
			if (ret && ret.status === 'ATTrackingManagerAuthorizationStatusAuthorized') {

				const IDFV = myPlugin.getIdentifierForVendor()
				console.log('IDFV ret:', IDFV)

				const IDFA = myPlugin.getAdvertisingIdentifier()
				console.log('IDFA ret:', IDFA)
				
				wx.showModal({
					title: '成功',
					content: `IDFA: ${IDFA}`,
					confirmText: '确定',
					showCancel: false,
					complete: (res) => {}
				})

			} else {
				wx.showModal({
					title: '失败',
					content: `获取失败：${ret.status}`,
					complete: (res) => {}
				})
			}
    })
  },

  copyLink() {
    wx.setClipboardData({
      data: 'https://dev.weixin.qq.com/docs/framework/dev/plugin/iosPlugin.html',
    })
  }
})