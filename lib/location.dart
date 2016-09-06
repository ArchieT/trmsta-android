library trmsta_android.location;

import "dart:jni";

final Context = Java.getClass('android.content.Context');
final LocationManager = Java.getClass('android.location.LocationManager');

getLastLocation() {
  final context = new JavaObject(JniApi.getApplicationContext());
  final locationManager = context.getSystemService(Context.LOCATION_SERVICE);

  return locationManager.getLastKnownLocation(LocationManager.PASSIVE_PROVIDER);
}
