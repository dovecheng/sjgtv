import 'package:quiver/core.dart' as quiver;
import 'package:base/extension.dart';
import 'package:mime/mime.dart' as mime;
// ignore: implementation_imports
import 'package:mime/src/default_extension_map.dart';
import 'package:path/path.dart' as p;

/// MIME类型
class MimeTypeModel {
  /// MIME类型 列表
  static final List<MimeTypeModel> mapping = defaultExtensionMap.entries
      .map(
        (MapEntry<String, String> e) => e.value
            .split('/')
            .let((List<String> it) => MimeTypeModel(e.key, it.first, it.last)),
      )
      .toList();

  /// 支持的 MIME类型
  ///
  /// * 3ds: image/x-3ds
  /// * 3g2: video/3gpp2
  /// * 3gp: video/3gpp
  /// * aac: audio/x-aac
  /// * adp: audio/adpcm
  /// * aif: audio/x-aiff
  /// * aifc: audio/x-aiff
  /// * aiff: audio/x-aiff
  /// * asf: video/x-ms-asf
  /// * asx: video/x-ms-asf
  /// * au: audio/basic
  /// * avi: video/x-msvideo
  /// * bmp: image/bmp
  /// * btif: image/prs.btif
  /// * caf: audio/x-caf
  /// * cgm: image/cgm
  /// * cmx: image/x-cmx
  /// * djv: image/vnd.djvu
  /// * djvu: image/vnd.djvu
  /// * doc: application/msword
  /// * docx: application/vnd.openxmlformats-officedocument.wordprocessingml.document
  /// * dra: audio/vnd.dra
  /// * dts: audio/vnd.dts
  /// * dtshd: audio/vnd.dts.hd
  /// * dvb: video/vnd.dvb.file
  /// * dwg: image/vnd.dwg
  /// * dxf: image/vnd.dxf
  /// * ecelp4800: audio/vnd.nuera.ecelp4800
  /// * ecelp7470: audio/vnd.nuera.ecelp7470
  /// * ecelp9600: audio/vnd.nuera.ecelp9600
  /// * eol: audio/vnd.digital-winds
  /// * f4v: video/x-f4v
  /// * fbs: image/vnd.fastbidsheet
  /// * fh: image/x-freehand
  /// * fh4: image/x-freehand
  /// * fh5: image/x-freehand
  /// * fh7: image/x-freehand
  /// * fhc: image/x-freehand
  /// * flac: audio/x-flac
  /// * fli: video/x-fli
  /// * flv: video/x-flv
  /// * fpx: image/vnd.fpx
  /// * fst: image/vnd.fst
  /// * fvt: video/vnd.fvt
  /// * g3: image/g3fax
  /// * gif: image/gif
  /// * h261: video/h261
  /// * h263: video/h263
  /// * h264: video/h264
  /// * ico: image/x-icon
  /// * ief: image/ief
  /// * jpe: image/jpeg
  /// * jpeg: image/jpeg
  /// * jpg: image/jpeg
  /// * jpgm: video/jpm
  /// * jpgv: video/jpeg
  /// * jpm: video/jpm
  /// * kar: audio/midi
  /// * ktx: image/ktx
  /// * lvp: audio/vnd.lucent.voice
  /// * m1v: video/mpeg
  /// * m2a: audio/mpeg
  /// * m2v: video/mpeg
  /// * m3a: audio/mpeg
  /// * m3u: audio/x-mpegurl
  /// * m4a: audio/mp4
  /// * m4u: video/vnd.mpegurl
  /// * m4v: video/x-m4v
  /// * mdi: image/vnd.ms-modi
  /// * mid: audio/midi
  /// * midi: audio/midi
  /// * mj2: video/mj2
  /// * mjp2: video/mj2
  /// * mk3d: video/x-matroska
  /// * mka: audio/x-matroska
  /// * mks: video/x-matroska
  /// * mkv: video/x-matroska
  /// * mmr: image/vnd.fujixerox.edmics-mmr
  /// * mng: video/x-mng
  /// * mov: video/quicktime
  /// * movie: video/x-sgi-movie
  /// * mp2: audio/mpeg
  /// * mp2a: audio/mpeg
  /// * mp3: audio/mpeg
  /// * mp4: video/mp4
  /// * mp4a: audio/mp4
  /// * mp4v: video/mp4
  /// * mpe: video/mpeg
  /// * mpeg: video/mpeg
  /// * mpg: video/mpeg
  /// * mpg4: video/mp4
  /// * mpga: audio/mpeg
  /// * mxu: video/vnd.mpegurl
  /// * npx: image/vnd.net-fpx
  /// * oga: audio/ogg
  /// * ogg: audio/ogg
  /// * ogv: video/ogg
  /// * pbm: image/x-portable-bitmap
  /// * pct: image/x-pict
  /// * pcx: image/x-pcx
  /// * pdf: application/pdf
  /// * pgm: image/x-portable-graymap
  /// * pic: image/x-pict
  /// * png: image/png
  /// * pnm: image/x-portable-anymap
  /// * ppm: image/x-portable-pixmap
  /// * ppt: application/vnd.ms-powerpoint
  /// * pptx: application/vnd.openxmlformats-officedocument.presentationml.presentation
  /// * psd: image/vnd.adobe.photoshop
  /// * pya: audio/vnd.ms-playready.media.pya
  /// * pyv: video/vnd.ms-playready.media.pyv
  /// * qt: video/quicktime
  /// * ra: audio/x-pn-realaudio
  /// * ram: audio/x-pn-realaudio
  /// * ras: image/x-cmu-raster
  /// * rgb: image/x-rgb
  /// * rip: audio/vnd.rip
  /// * rlc: image/vnd.fujixerox.edmics-rlc
  /// * rmi: audio/midi
  /// * rmp: audio/x-pn-realaudio-plugin
  /// * s3m: audio/s3m
  /// * sgi: image/sgi
  /// * sid: image/x-mrsid-image
  /// * sil: audio/silk
  /// * smv: video/x-smv
  /// * snd: audio/basic
  /// * spx: audio/ogg
  /// * svg: image/svg+xml
  /// * svgz: image/svg+xml
  /// * tga: image/x-tga
  /// * tif: image/tiff
  /// * tiff: image/tiff
  /// * txt: text/plain
  /// * uva: audio/vnd.dece.audio
  /// * uvg: image/vnd.dece.graphic
  /// * uvh: video/vnd.dece.hd
  /// * uvi: image/vnd.dece.graphic
  /// * uvm: video/vnd.dece.mobile
  /// * uvp: video/vnd.dece.pd
  /// * uvs: video/vnd.dece.sd
  /// * uvu: video/vnd.uvvu.mp4
  /// * uvv: video/vnd.dece.video
  /// * uvva: audio/vnd.dece.audio
  /// * uvvg: image/vnd.dece.graphic
  /// * uvvh: video/vnd.dece.hd
  /// * uvvi: image/vnd.dece.graphic
  /// * uvvm: video/vnd.dece.mobile
  /// * uvvp: video/vnd.dece.pd
  /// * uvvs: video/vnd.dece.sd
  /// * uvvu: video/vnd.uvvu.mp4
  /// * uvvv: video/vnd.dece.video
  /// * viv: video/vnd.vivo
  /// * vob: video/x-ms-vob
  /// * wav: audio/x-wav
  /// * wax: audio/x-ms-wax
  /// * wbmp: image/vnd.wap.wbmp
  /// * wdp: image/vnd.ms-photo
  /// * weba: audio/webm
  /// * webm: video/webm
  /// * webp: image/webp
  /// * wm: video/x-ms-wm
  /// * wma: audio/x-ms-wma
  /// * wmv: video/x-ms-wmv
  /// * wmx: video/x-ms-wmx
  /// * wvx: video/x-ms-wvx
  /// * xbm: image/x-xbitmap
  /// * xif: image/vnd.xiff
  /// * xls: application/vnd.ms-excel
  /// * xlsx: application/vnd.openxmlformats-officedocument.spreadsheetml.sheet
  /// * xm: audio/xm
  /// * xpm: image/x-xpixmap
  /// * xwd: image/x-xwindowdump
  static final List<MimeTypeModel> supported = mapping
      .where(
        (MimeTypeModel e) =>
            const [
              'pdf',
              'docx',
              'doc',
              'xlsx',
              'xls',
              'pptx',
              'ppt',
              'txt',
            ].contains(e.extension) ||
            const ['audio', 'video', 'image'].contains(e.type),
      )
      .toList();

  /// 文件后缀名
  ///
  /// 例: 1.txt = txt
  final String extension;

  /// MIME类型
  ///
  /// * application
  /// * video
  /// * audio
  /// * text
  /// * ...
  final String type;

  /// MIME子类型
  final String subType;

  const MimeTypeModel(this.extension, this.type, this.subType);

  /// 是否支持的
  bool get isSupported => supported.contains(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MimeTypeModel &&
          runtimeType == other.runtimeType &&
          extension == other.extension &&
          type == other.type &&
          subType == other.subType;

  @override
  int get hashCode => quiver.hash3(extension, type, subType);

  @override
  String toString() =>
      '${isSupported ? 'supported' : 'unsupported'} $extension: $type/$subType';

  /// 查找
  static MimeTypeModel? lookupMimeType(String path) {
    Uri uri = Uri.parse(path);
    String extension = p.extension(uri.path);
    if (extension.isNotEmpty) {
      extension = extension.substring(1);
    } else {
      extension = uri.path;
    }
    extension = extension.toLowerCase();
    String? types = mime.lookupMimeType(extension);
    return types
        ?.split('/')
        .let((List<String> it) => MimeTypeModel(extension, it.first, it.last));
  }
}
