var Rope = cc.Class.extend({
    space:null,
    shape:null,
    characterJoint:null,
    slingshotJoint:null,
    dampening:10,
    length:.5,
    stiffness:100,
    links:[],
    startLink:null,
    endLink:null,


    /** Constructor
     * @param {cc.SpriteBatchNode *}
     * @param {cp.Space *}
     * @param {cc.p}
     */
    ctor:function (spriteSheet, space, length, characterBody, slingshotBody, startPoint) {
        this.space = space;
        var sprite = cc.PhysicsSprite.create(res.chainlink_png);
        // init physics
        var width = sprite.getContentSize().width;
        var height = sprite.getContentSize().height;

        var body = new cp.Body(1, cp.momentForBox(1, width, height));
        sprite.setBody(body);
        body.p = startPoint;
        spriteSheet.addChild(sprite);
        this.startLink = body;
        this.space.addBody(this.startLink);

        var zeroPoint = cc.p(0,0);
        var leftPoint = cc.p(-width / 3,0);
        var rightPoint = cc.p(width / 3,0);
        this.characterJoint = new cp.DampedSpring(body, characterBody, rightPoint, zeroPoint, this.length, this.stiffness, this.dampening);
        this.space.addConstraint(this.characterJoint);
        spriteSheet.addChild(this.characterJoint);

        this.links.push(body);
        for (var i = 0; i < length; i++)
        {
            var sprite = cc.PhysicsSprite.create(res.chainlink_png);
            this.endLink = new cp.Body(1, cp.momentForBox(1, width, height));
            sprite.setBody(this.endLink);
            spriteSheet.addChild(sprite);
            this.space.addBody(this.endLink);
            var midJoint = new cp.DampedSpring(this.endLink, this.links[i], leftPoint, rightPoint, this.length, this.stiffness, this.dampening);
            this.space.addConstraint(midJoint);
            spriteSheet.addChild(midJoint);
            this.links.push(this.endLink);
        }

        this.slingshotJoint = new cp.DampedSpring(slingshotBody, this.endLink, zeroPoint, leftPoint, this.length, this.stiffness, this.dampening);
        this.space.addConstraint(this.slingshotJoint);
        spriteSheet.addChild(this.slingshotJoint);
    },

    removeAll:function() {
        this.space.removeBody(this.startLink);
        for (var i = 0; i < this.links.length; i++)
        {
            this.space.removeBody(links[0]);
        }
    },

    disconnectFromCharacter:function() {
        this.space.removeConstraint(this.characterJoint);
        this.characterJoint = null;
    },

    removeFromParent:function () {
        this.space.removeStaticShape(this.shape);
        this.shape = null;
        this.sprite.removeFromParent();
        this.sprite = null;
    },

    getShape:function () {
        return this.shape;
    },

    getType:function () {
        return this.type;
    }
});