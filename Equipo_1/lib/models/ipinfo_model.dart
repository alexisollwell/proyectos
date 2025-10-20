class IpInfo {
  String ip;
  String ciudad;
  String estado;
  String pais;
  String loc;

  IpInfo({
    this.ip = "",
    this.ciudad = "",
    this.estado = "",
    this.pais = "",
    this.loc = "",
  });

  factory IpInfo.fromJson(Map<String, dynamic> json) {
    return IpInfo(
      ip: json['ip'] ?? "",
      ciudad: json['city'] ?? "",
      estado: json['region'] ?? "",
      pais: json['country'] ?? "",
      loc: json['loc'] ?? "",
    );
  }
}
