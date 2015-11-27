#pragma strict
var speed : Vector3;

function Start() {

transform.Rotate(speed * Random.Range(0.0,1.0));

}

function Update () {

transform.Rotate(speed * Time.deltaTime);

}