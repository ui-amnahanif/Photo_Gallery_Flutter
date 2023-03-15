class Album {
  late int id;
  late String title;
  late String cover_photo;
  Album();

  Map<String, dynamic> toMap() {
    Map<String, dynamic> amap = Map<String, dynamic>();
    amap["id"] = id;
    amap["title"] = title;
    amap["cover_photo"] = cover_photo;
    return amap;
  }

  Album.fromMap(Map<String, dynamic> a) {
    id = a["id"];
    title = a["title"];
    cover_photo = a["cover_photo"];
  }

  // static List<Album> getAlbums() {
  //   List<Album> alist = [];
  //   Album a = new Album();
  //   a.id = 1;
  //   a.title = "Hassan";
  //   a.image = "assets/images/boy1.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Hassan";
  //   a.image = "assets/images/boy2.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl1.png";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl2.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl4.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl5.jpg";
  //   alist.add(a);
  //   a = new Album();
  //   a.id = 1;
  //   a.title = "Amna";
  //   a.image = "assets/images/girl1.png";
  //   alist.add(a);
  //   return alist;
  // }
}
