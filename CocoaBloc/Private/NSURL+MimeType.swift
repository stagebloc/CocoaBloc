//
//  NSURL+MimeType.swift
//  CocoaBloc
//
//  Created by David Warner on 3/24/16.
//  Copyright © 2016 Fullscreen Direct. All rights reserved.
//

import Foundation
import MobileCoreServices

extension Foundation.URL {
	
	internal func photoMime() -> String {
		let ext = self.pathExtension
		guard let UTIRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext as CFString, nil) else {
				return ""
		}
		let UTI = UTIRef.takeUnretainedValue()
		UTIRef.release()
		
		guard let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType) else { return "" }
		MIMETypeRef.release()
		return MIMETypeRef.takeUnretainedValue() as String
	}
	
}
