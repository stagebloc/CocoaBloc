//
//  NSURL+MimeType.swift
//  CocoaBloc
//
//  Created by David Warner on 3/24/16.
//  Copyright © 2016 StageBloc. All rights reserved.
//

import Foundation
import MobileCoreServices

extension NSURL {
	
	func photoMime() -> String? {
		
		guard let ext = self.pathExtension,
			let UTIRef = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, ext, nil) else { return nil }
		
		let UTI = UTIRef.takeUnretainedValue()
		UTIRef.release()
		
		guard let MIMETypeRef = UTTypeCopyPreferredTagWithClass(UTI, kUTTagClassMIMEType) else { return nil }
		MIMETypeRef.release()
		return MIMETypeRef.takeUnretainedValue() as String
	}
}
