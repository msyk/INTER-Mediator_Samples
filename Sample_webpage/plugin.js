import {
  Uppy,
  Dashboard,
  ImageEditor,
  Compressor,
  XHRUpload
} from "https://releases.transloadit.com/uppy/v5.2.4/uppy.min.mjs"
import Japanese from "https://esm.sh/@uppy/locales@5/lib/ja_JP"
import English from "https://esm.sh/@uppy/locales@5/lib/en_US"

IMParts_Catalog.uppy = {
  optionsSeed: {
    inline: true,
    showProgressDetails: true,
    proudlyDisplayPoweredByUppy: true,
    width: 400,
    height: 440,
    hideUploadButton: false,
  },
  useImageEditor: true,
  useCompressor: true,
  delayUpdate: true,
  fullUpdate: false,
  // localeName: Japanese,

  instantiate: function (targetNode) {
    const nodeId = targetNode.getAttribute('id')
    this.ids.push(nodeId)
    targetNode._im_getComponentId = (function () {
      const theId = nodeId
      return function () {
        return theId
      }
    })()
    targetNode._im_setValue = (function () {
      const theId = nodeId
      return function (str) {
        IMParts_Catalog.uppy.values[theId] = str
      }
    })()
    targetNode._im_getValue = (function () {
      const theId = nodeId
      return function () {
        if (IMParts_Catalog.uppy.values[theId]) {
          return IMParts_Catalog.uppy.values[theId]
        }
        return null
      }
    })()
  },

  ids: [],
  values: {},

  finish: function () {
    for (let i = 0; i < this.ids.length; i++) {
      const targetId = this.ids[i]
      const cInfo = IMLibContextPool.getContextInfoFromId(targetId, '')
      const uppy = new Uppy()
      const options = {...IMParts_Catalog.uppy.optionsSeed}
      options.target = `#${targetId}`
      options.locale = IMParts_Catalog.uppy.localeName
      if (!cInfo) {
        options.hideUploadButton = true
        options.height -= 65
      }
      uppy.use(Dashboard, options)
      if (IMParts_Catalog.uppy.useImageEditor) {
        uppy.use(ImageEditor, {target: Dashboard})
      }
      if (IMParts_Catalog.uppy.useCompressor) {
        uppy.use(Compressor)
      }
      if (cInfo) { // In case of an expanding context (not Post Only Mode)
        const keyValue = cInfo.record.split('=')
        const metaData = {
          access: 'uploadfile',
          _im_contextname: cInfo.context.contextName,
          _im_field: cInfo.field,
          _im_keyfield: keyValue[0],
          _im_keyvalue: keyValue[1],
          authuser: IMLibAuthentication.authUser()
        }
        const authData = IMParts_Catalog.uppy.setupAuthData()
        uppy.setMeta({...metaData, ...authData})

        uppy.use(XHRUpload, {
          endpoint: INTERMediatorOnPage.getEntryPath() + '?access=uploadfile',
          method: "post",
          formData: true,
          limit: 6,
          bundle: true,
          allowedMetaFields: [
            'access', '_im_contextname', '_im_field', '_im_keyfield', '_im_keyvalue',
            'authuser', 'clientid', 'response', 'response2m', 'response2'
          ],
          onBeforeRequest:
            (() => {
              const idValue = targetId
              return async (xhr) => {
                if (INTERMediatorOnPage.doBeforeValueChange) {
                  INTERMediatorOnPage.doBeforeValueChange(idValue)
                }
              }
            })(),
          onAfterResponse:
            (() => {
              const idValue = targetId
              const updateContext = cInfo.context.contextName
              return async (xhr) => {
                console.log(xhr.status)
                if (xhr.status === 200) {
                  const result = INTERMediator_DBAdapter.uploadFileAfterSucceed(xhr.responseText, null, null, true)
                  if (INTERMediatorOnPage.doAfterValueChange) {
                    INTERMediatorOnPage.doAfterValueChange(idValue)
                  }
                  if (result) {
                    INTERMediatorLog.flushMessage()
                    let updateFunc;
                    if (IMParts_Catalog.uppy.fullUpdate) {
                      updateFunc = () => {
                        INTERMediator.construct()
                      }
                    } else if (updateContext) {
                      updateFunc = () => {
                        INTERMediator.construct(IMLibContextPool.contextFromName(updateContext))
                      }
                    }
                    if (IMParts_Catalog.uppy.delayUpdate) {
                      setTimeout(updateFunc, 4000)
                    } else {
                      updateFunc()
                    }
                  }
                } else {
                  alert(`Error(${xhr.status})${xhr.responseText}`)
                }
              }
            })()
        })
      } else { // In case of a post-only mode
        uppy.on('file-added', (() => {
            const theId = targetId
            return (file) => {
              if (!IMParts_Catalog.uppy.values[theId]) {
                IMParts_Catalog.uppy.values[theId] = []
              }
              IMParts_Catalog.uppy.values[theId].push({
                file: file.data,
                kind: 'attached'
              })
            }
          })()
        )
        uppy.on('file-removed', ((file) => {
            const theId = targetId
            return (file) => {
              let counter = 0;
              for (const aFile of IMParts_Catalog.uppy.values[theId]) {
                if (aFile.file.name === file.name) {
                  IMParts_Catalog.uppy.values[theId].splice(counter, 1)
                  return
                }
                counter += 1
              }
            }
          })()
        )
      }
    }
    this.ids = []
  },

  // Basically this is private method
  setupAuthData: () => {
    const metaData = {}
    if (IMLibAuthentication.authUser() && IMLibAuthentication.authUser().length > 0) {
      metaData['clientid'] = IMLibAuthentication.clientId()

      if ((IMLibAuthentication.authHashedPassword()
          || IMLibAuthentication.authHashedPassword2m()
          || IMLibAuthentication.authHashedPassword2())
        && IMLibAuthentication.authChallenge) {
        if (IMLibAuthentication.passwordHash < 1.1 && IMLibAuthentication.authHashedPassword()) {
          const shaObj = new jsSHA('SHA-256', 'TEXT')
          shaObj.setHMACKey(IMLibAuthentication.authChallenge, 'TEXT')
          shaObj.update(IMLibAuthentication.authHashedPassword())
          metaData['response'] = shaObj.getHMAC('HEX')
        }
        if (IMLibAuthentication.passwordHash < 1.6 && IMLibAuthentication.authHashedPassword2m()) {
          const shaObj = new jsSHA('SHA-256', 'TEXT')
          shaObj.setHMACKey(IMLibAuthentication.authChallenge, 'TEXT')
          shaObj.update(IMLibAuthentication.authHashedPassword2m())
          metaData['response2m'] = shaObj.getHMAC('HEX')
        }
        if (IMLibAuthentication.passwordHash < 2.1 && IMLibAuthentication.authHashedPassword2()) {
          const shaObj = new jsSHA('SHA-256', 'TEXT')
          shaObj.setHMACKey(IMLibAuthentication.authChallenge, 'TEXT')
          shaObj.update(IMLibAuthentication.authHashedPassword2())
          metaData['response2'] = shaObj.getHMAC('HEX')
        }
      }
    }
    return metaData
  }
}
