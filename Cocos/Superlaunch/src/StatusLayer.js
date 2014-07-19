var StatusLayer = cc.Layer.extend({
    labelTime:null,
    labelDistance:null,
    lifeBar:null,
    boostBar:null,
    lazarBar:null,
    coins:0,
    lifeLabel:"Life",
    timeLabel:"Time:",
    distanceLabel:"Meters",
    boostLabel:"Boost",
    lazarLabel:"Lazar",

    ctor:function () {
        this._super();
        this.init();
    },

    init:function () {
        this._super();

        var winsize = cc.director.getWinSize();

        this.labelTime = cc.LabelTTF.create(this.timeLabel + "100", "Helvetica", 20);
        this.labelTime.setColor(cc.color(0,0,0));//black color
        this.labelTime.setPosition(cc.p(70, winsize.height - 20));
        this.addChild(this.labelTime);

        this.labelDistance = cc.LabelTTF.create("0" + this.distanceLabel, "Helvetica", 20);
        this.labelDistance.setPosition(cc.p(winsize.width - 70, winsize.height - 20));
        this.addChild(this.labelDistance);

        this.lifeBar = cc.LabelTTF.create("100" + this.lifeLabel, "Helvetica", 20);
        this.lifeBar.setPosition(cc.p(winsize.width / 2, 20));
        this.addChild(this.lifeBar);

        this.boostBar = cc.LabelTTF.create("100" + this.boostLabel, "Helvetica", 20);
        this.boostBar.setPosition(cc.p(winsize.width - 70, 20));
        this.addChild(this.boostBar);

        this.lazarBar = cc.LabelTTF.create("100" + this.lazarLabel, "Helvetica", 20);
        this.lazarBar.setPosition(cc.p(70, 20));
        this.addChild(this.lazarBar);
    },

    updateDistance:function (pixels){
        this.labelDistance.setString(parseInt(pixels / 10) + this.distanceLabel);
    },

    updateTime:function (timeRemaining) {
        this.labelTime.setString(this.timeLabel + parseInt(timeRemaining));
    },

    updateLife:function (remainder) {
        this.lifeBar.setString(parseInt(remainder) + this.lifeLabel);
    },

    updateBoost:function (remainder) {
        this.boostBar.setString(parseInt(remainder) + this.boostLabel);
    },

    updateLazar:function (remainder) {
        this.lazarBar.setString(parseInt(remainder) + this.lazarLabel);
    }
});