var PlayScene = cc.Scene.extend({
    space:null,
    gamePlayLayer:null,
    gameLayer:null,
    shapesToRemove:[],
    impulsesToApply:[],

    onEnter:function () {
        this._super();
        this.initPhysics();
        this.gameLayer = cc.Layer.create();
        //add the three layers in the correct order
        this.gameLayer.addChild(new BackgroundLayer(this.space), 0, TagOfLayer.Background);
        this.gameLayer.addChild(new GamePlayLayer(this.space), 0, TagOfLayer.GamePlay);
        this.addChild(this.gameLayer);
        this.addChild(new StatusLayer(this.gameLayer.getChildByTag(TagOfLayer.GamePlay)), 0, TagOfLayer.Status);
        this.shapesToRemove = [];
        this.scheduleUpdate();
    },

    // init space of chipmunk
    initPhysics:function() {
        //1. new space object
        this.space = new cp.Space();
        //2. setup the  Gravity
        this.space.gravity = cp.v(0, -350);

        // 3. set up Walls
        var wallBottom = new cp.SegmentShape(this.space.staticBody,
            cp.v(0, g_groundHeight),// start point
            cp.v(4294967295, g_groundHeight),// MAX INT:4294967295
            0);// thickness of wall
        this.space.addStaticShape(wallBottom);

        // setup chipmunk CollisionHandler
        this.space.addCollisionHandler(SpriteTag.character, SpriteTag.star,
            this.collisionStarBegin.bind(this), null, null, null);
        this.space.addCollisionHandler(SpriteTag.character, SpriteTag.bacon,
            this.collisionBaconBegin.bind(this), null, null, null);
    },

    collisionStarBegin:function (arbiter, space) {
        var shapes = arbiter.getShapes();
        // shapes[0] is character
        //TODO:Find a way to pass the shape directly from handler
        this.impulsesToApply.push([cp.v(20,400), cp.v(-2,0)]);
        this.shapesToRemove.push(shapes[1]);
    },

    collisionBaconBegin:function (arbiter, space) {
        cc.log("==game over");
    },

    update:function(dt) {
        //chipmunk step
        this.space.step(dt);

        // Simulation cpSpaceAddPostStepCallback
        for(var i = 0; i < this.shapesToRemove.length; i++) {
            var shape = this.shapesToRemove[i];
            this.gameLayer.getChildByTag(TagOfLayer.Background).removeObjectByShape(shape);
        }
        this.shapesToRemove = [];

        this.gameLayer.getChildByTag(TagOfLayer.GamePlay).applyImpulses(this.impulsesToApply);
        this.impulsesToApply = [];
        var gamePlayLayer = this.gameLayer.getChildByTag(TagOfLayer.GamePlay);
        var newX = 30 - gamePlayLayer.getEyeX();
        var eyeY = gamePlayLayer.getEyeY();
        var newY = -45
        if (eyeY > 175)
        {
            newY = 130 - eyeY;
        }

        this.gameLayer.setPosition(cc.p(newX,newY));
    }
});