-- Decompiled with the Synapse X Luau decompiler.

local v1 = {};
local v2 = require(game.ReplicatedStorage.Modules:WaitForChild("UniversalTables"));
local l__Players__3 = game:GetService("Players");
local l__ReplicatedStorage__4 = game:GetService("ReplicatedStorage");
local l__Remotes__5 = l__ReplicatedStorage__4:WaitForChild("Remotes");
local l__Modules__6 = game.ReplicatedStorage:WaitForChild("Modules");
local l__SFX__7 = l__ReplicatedStorage__4:WaitForChild("SFX");
local l__LocalPlayer__8 = l__Players__3.LocalPlayer;
local l__RootScanHeight__9 = v2.UniversalTable.GameSettings.RootScanHeight;
local v10 = { "LeftFoot", "LeftHand", "LeftLowerArm", "LeftLowerLeg", "LeftUpperArm", "LeftUpperLeg", "LowerTorso", "RightFoot", "RightHand", "RightLowerArm", "RightLowerLeg", "RightUpperArm", "RightUpperLeg", "RightUpperLeg", "UpperTorso", "Head", "FaceHitBox", "HeadTopHitBox" };
local u1 = require(game.ReplicatedStorage.Modules:WaitForChild("FunctionLibraryExtension"));
local function u2(p1, p2, p3, p4, p5, p6)
	if p5 then
		local v11 = math.min(1.5 / math.max(p6, 0), 90);
		local v12 = 0;
		local v13 = tick();
		while true do
			local v14 = v11 * (1 * (tick() - v13) * 60);
			local v15 = v12 + v14;
            local v16
			if v15 > 90 then
				v16 = 90;
			else
				v16 = v15;
			end;
			v12 = v16;
			if p1.CoordinateFrame.lookVector.Y > 0.98 then
				break;
			end;
			p1.CoordinateFrame = p1.CoordinateFrame * CFrame.Angles(p2 / (90 / v14), p3 / (90 / v14), p4 / (90 / v14));
			if v12 == 90 then
				break;
			end;
			v13 = tick();
			game:GetService("RunService").Stepped:wait();		
		end;
	else
		p1.CoordinateFrame = p1.CoordinateFrame * CFrame.Angles(p2, p3, p4);
	end;
end;
function RecoilCamera(p7, p8, p9, p10, p11)
	local v17 = 0;
	local v18 = 0;
	if p7 then
		v17 = p7.y.Value * (p8 * 0.004 / 3) * 2;
		v18 = p7.x.Value * (p9 * 0.004 / 3) * 2;
	end;
	local l__CurrentCamera__3 = workspace.CurrentCamera;
	coroutine.wrap(function()
		u2(l__CurrentCamera__3, v17, v18, 0, true, 0.06);
	end)();
end;
local l__RangedWeapons__4 = l__ReplicatedStorage__4:WaitForChild("RangedWeapons");
local u5 = l__ReplicatedStorage__4:WaitForChild("Players"):WaitForChild(l__LocalPlayer__8.Name);
local l__Temp__6 = game.ReplicatedStorage.Temp;
local l__VFX__7 = game.ReplicatedStorage:WaitForChild("VFX");
local l__Debris__8 = game:GetService("Debris");
local function u9(p12, p13)
	local v19 = nil;
	local v20 = nil;
	local v21 = nil;
	local v22 = nil;
	local l__Keypoints__23 = p12.Keypoints;
	for v24 = 1, #l__Keypoints__23 do
		if v24 == 1 then
			v19 = NumberSequenceKeypoint.new(l__Keypoints__23[v24].Time, l__Keypoints__23[v24].Value * p13);
		elseif v24 == 2 then
			v20 = NumberSequenceKeypoint.new(l__Keypoints__23[v24].Time, l__Keypoints__23[v24].Value * p13);
		elseif v24 == 3 then
			v21 = NumberSequenceKeypoint.new(l__Keypoints__23[v24].Time, l__Keypoints__23[v24].Value * p13);
		elseif v24 == 4 then
			v22 = NumberSequenceKeypoint.new(l__Keypoints__23[v24].Time, l__Keypoints__23[v24].Value * p13);
		end;
	end;
	return NumberSequence.new({ v19, v20, v21, v22 });
end;
local u10 = v2.ReturnTable("GlobalIgnoreListProjectile");
local l__FireProjectile__11 = game.ReplicatedStorage.Remotes.FireProjectile;
local u12 = require(game.ReplicatedStorage.Modules:WaitForChild("VFX"));
local l__ProjectileInflict__13 = game.ReplicatedStorage.Remotes.ProjectileInflict;
local l__RunService__14 = game:GetService("RunService");
function v1.CreateBullet(p14, p15, p16, p17, p18, p19, p20, p21, p22, settings)
    local suc,err = pcall(function()
        
        local l__Character__25 = l__LocalPlayer__8.Character;
        local l__HumanoidRootPart__26 = l__Character__25.HumanoidRootPart;
        if not l__Character__25:FindFirstChild(p15.Name) then
            return;
        end;
        local v27
        if p17.Item.Attachments:FindFirstChild("Front") then
            v27 = p17.Item.Attachments.Front:GetChildren()[1].Barrel;
            local l__Barrel__28 = p16.Attachments.Front:GetChildren()[1].Barrel;
        else
            v27 = p17.Item.Barrel;
            local l__Barrel__29 = p16.Barrel;
        end;
        print("pass1")
        local l__ItemRoot__30 = p16.ItemRoot;
        local l__ItemProperties__31 = p15.ItemProperties;
        local v32 = l__RangedWeapons__4:FindFirstChild(p15.Name);
        local l__SpecialProperties__33 = l__ItemProperties__31:FindFirstChild("SpecialProperties");
        local v34 = u5.Status.GameplayVariables:GetAttribute("EquipId");
        local v35 = l__ReplicatedStorage__4.AmmoTypes:FindFirstChild(p19);
        local v36 = l__SpecialProperties__33 and l__SpecialProperties__33:GetAttribute("TracerColor") or v32:GetAttribute("ProjectileColor");
        local v37 = v32:GetAttribute("BulletMaterial");
        local v38 = v35:GetAttribute("ProjectileDrop");
        local v39 = v35:GetAttribute("Drag");
        local v40 = v35:GetAttribute("MuzzleVelocity");
        local v41 = v35:GetAttribute("Tracer");
        local v42 = v32:GetAttribute("RecoilRecoveryTimeMod");
        local v43 = v35:GetAttribute("AccuracyDeviation");
        local v44 = v35:GetAttribute("Pellets");
        local v45 = v35:GetAttribute("Damage");
        local v46 = v35:GetAttribute("Arrow");
        local v47 = v35:GetAttribute("ProjectileWidth");
        local v48 = v35:GetAttribute("ArmorPen");
        print("pass2")
        local originalProjectileDrop = v38
        local originalMuzzleVelocity = v40
        if settings.fastBullet then
            if settings.currentTargetPart then else
                v40 = 5000
            end
        end
        if settings.noBulletDrop then
            v38 = 0
        end
    
        if p21 and v32:FindFirstChild("RecoilPattern") then
            local v49 = #v32.RecoilPattern:GetChildren();
            if p21 == 1 then
                local v50 = {
                    x = {
                        Value = v32.RecoilPattern["1"].x.Value
                    }, 
                    y = {
                        Value = v32.RecoilPattern["1"].y.Value
                    }
                };
            else
                v50 = v32.RecoilPattern:FindFirstChild(tostring(p21));
            end;
        else
            v50 = {
                x = {
                    Value = math.random(-5, 5) * 0.01
                }, 
                y = {
                    Value = math.random(5, 10) * 0.01
                }
            };
        end;
        print("pass3")
        local v51 = u5.Status.GameplayVariables:GetAttribute("Stance") == "Crouching";
        local v52 = l__ItemProperties__31.Tool:GetAttribute("MuzzleDevice") and "Default" or "Default";
        local v53 = v35:GetAttribute("RecoilStrength");
        local v54 = v51 and v53 * 0.9 or v53;
        local v55 = v51 and v53 * 0.9 or v53;
        local l__Attachments__56 = p15:FindFirstChild("Attachments");
        if l__Attachments__56 then
            local v57 = l__Attachments__56:GetChildren();
            for v58 = 1, #v57 do
                local v59 = v57[v58]:FindFirstChildOfClass("StringValue");
                if v59 and v59.ItemProperties:FindFirstChild("Attachment") and (not v59.ItemProperties:GetAttribute("Durability") or v59.ItemProperties:GetAttribute("Durability") > 0) then
                    local l__Attachment__60 = v59.ItemProperties.Attachment;
                    local v61 = l__Attachment__60:GetAttribute("Recoil");
                    if v61 then
                        v54 = v54 + v61 * l__Attachment__60:GetAttribute("HRecoilMod");
                        v55 = v55 + v61 * l__Attachment__60:GetAttribute("VRecoilMod");
                    end;
                    local v62 = l__Attachment__60:GetAttribute("MuzzleDevice");
                    if v62 then
                        v52 = v62;
                        if p17.Item.Attachments.Muzzle:FindFirstChild(v59.Name):FindFirstChild("BarrelExtension") then
                            v27 = p17.Item.Attachments.Muzzle:FindFirstChild(v59.Name):FindFirstChild("BarrelExtension");
                            local l__BarrelExtension__63 = p16.Attachments.Muzzle:FindFirstChild(v59.Name):FindFirstChild("BarrelExtension");
                        end;
                    end;
                end;
            end;
        end;
        print("pass4")
        if v52 == "Suppressor" then
            if tick() - p20 < 0.8 then
                u1:PlaySoundV2(l__ItemRoot__30.FireSoundSupressed, l__ItemRoot__30.FireSoundSupressed.TimeLength, l__Temp__6);
            else
                u1:PlaySoundV2(l__ItemRoot__30.FireSoundSupressed, l__ItemRoot__30.FireSoundSupressed.TimeLength, l__Temp__6);
            end;
        elseif tick() - p20 < 0.8 then
            u1:PlaySoundV2(l__ItemRoot__30.FireSound, l__ItemRoot__30.FireSound.TimeLength, l__Temp__6);
        else
            u1:PlaySoundV2(l__ItemRoot__30.FireSound, l__ItemRoot__30.FireSound.TimeLength, l__Temp__6);
        end;
        print("pass4.5")
        if v32:GetAttribute("MuzzleEffect") == true then
            local v64 = l__SpecialProperties__33 and l__SpecialProperties__33:GetAttribute("MuzzleEffect");
            local v65
            print("pass4.6")
            if v64 then
                v65 = l__VFX__7.MuzzleEffects.Override:FindFirstChild(v64) or l__VFX__7.MuzzleEffects;
            else
                v65 = l__VFX__7.MuzzleEffects;
            end;
            print("pass4.7")
            local v66 = (v65:FindFirstChild(v52) or l__VFX__7.MuzzleEffects:FindFirstChild(v52)):GetChildren();
            local v67 = v66[math.random(1, #v66)];
            local v68 = v67.Particles:GetChildren();
            print("pass4.8")
            if v67:FindFirstChild("MuzzleLight") then
                local v69 = v67.MuzzleLight:Clone();
                v69.Range = math.clamp(v69.Range + math.random(-2, 2) / 2, 0, 50);
                v69.Enabled = true;
                l__Debris__8:AddItem(v69, 0.1);
                v69.Parent = v27;
            end;
            print("pass4.9")
            for v70 = 1, #v68 do
                if v68[v70].className == "ParticleEmitter" then
                    local v71 = v68[v70]:Clone();
                    local v72 = math.clamp(v45 / 45 / 2.4, 0, 0.6);
                    if v44 then
                        v72 = math.clamp(v45 * v44 / 45 / 2.4, 0, 0.6);
                    end;
                    local v73 = math.clamp(v72, 1, 10);
                    print("pass4.95")
                    v71.Lifetime = NumberRange.new(v71.Lifetime.Min * v73, v71.Lifetime.Max * v73);
                    v71.Size = u9(v71.Size, v72);
                    v71.Parent = v27;
                    v71:Emit(v71:GetAttribute("EmitCount") and 1);
                    l__Debris__8:AddItem(v71, v71.Lifetime.Max);
                end;
            end;
        end;
        print("pass5")
        local l__p__74 = l__HumanoidRootPart__26.CFrame.p;
        local l__LookVector__15 = p22.CFrame.LookVector;
        if settings.currentTargetPart then
            l__LookVector__15 = CFrame.new(v27.CFrame.Position, settings.currentTargetPart.Position).LookVector
        end
        local u16 = 0;
        local u17 = "";
        local u18 = false;
        local u19 = v40;
        local l__CurrentCamera__20 = workspace.CurrentCamera;
        local u21 = math.clamp(v40 / 2400, 0.7, 1.2);
        local u22 = v48;
        local function v75()
            print("pass7")
            local v76 = RaycastParams.new();
            v76.FilterType = Enum.RaycastFilterType.Blacklist;
            local v77 = { l__Character__25, p17, u10 };
            v76.FilterDescendantsInstances = v77;
            v76.IgnoreWater = false;
            v76.CollisionGroup = "WeaponRay";
            local v78 = tick();
            local v79 = l__LookVector__15;
            local v80 = u1:GetEstimatedCameraPosition(l__LocalPlayer__8);
            local v81 = v80 + l__LookVector__15 * 1000;
            if settings.noSpread then
                v43 = 0
            end
            if v43 then
                v81 = v81 + Vector3.new(math.random(-v43, v43), math.random(-v43, v43), math.random(-v43, v43));
                v79 = (v81 - v80).Unit;
            end;
            print("pass8")
            u16 = u16 + 1;
            if u16 == 1 then
                u17 = game.Players.LocalPlayer.UserId .. math.ceil(tick() * 20) / 20;
                coroutine.wrap(function()
                    if not l__FireProjectile__11:InvokeServer(v79, u17, false) then
                        script.Parent.Binds.AdjustBullets:Fire(v34, 1);
                    end;
                end)();
            elseif u16 > 1 then
                coroutine.wrap(function()
                    local v82 = l__FireProjectile__11:InvokeServer(v79, u17, true);
                end)();
            end;
            print("pass9")
            if not v44 or not u18 and math.floor(v44 * 0.2) < u16 then
                u18 = true;
                if settings.weaponRecoilMultiplier and settings.weaponRecoilMultiplier > 0 or not settings.weaponRecoilMultiplier then
                    local recoilValues = v50
                    if settings.weaponRecoilMultiplier and v50 then
                        recoilValues = recoilValues:Clone()
                        print(settings.weaponRecoilMultiplier)
                        recoilValues.x.Value = recoilValues.x.Value * settings.weaponRecoilMultiplier
                        recoilValues.y.Value = recoilValues.y.Value * settings.weaponRecoilMultiplier
                        l__Debris__8:AddItem(recoilValues, 5)
                    end
    
                    RecoilCamera(recoilValues, v54, v55, v42, p18);
                end
            end;
            print("pass10")
            local v83 = nil;
            local v84 = nil;
            if v41 then
                v83 = l__VFX__7.MuzzleEffects.Tracer:Clone();
                v83.Name = u17;
                v83.Color = v36;
                l__Debris__8:AddItem(v83, 10);
                v83.Position = Vector3.new(0, -100, 0);
                v83.Parent = game.Workspace.NoCollision.Effects;
                local l__AssemblyLinearVelocity__85 = l__HumanoidRootPart__26.AssemblyLinearVelocity;
                v84 = v27.Position;
            end;
            local v86 = {};
            local u23 = nil;
            local u24 = 0;
            local u25 = 0;
            local u26 = v80;
            local u27 = v79;
            local u28 = 0;
            local u29 = {};
            local u30 = {};
            local u31 = false;
            print("pass11")
            u23 = l__RunService__14.RenderStepped:Connect(function(p23)
                if settings.fastBullet then
                    u24 = 1
                else
                    u24 = u24 + p23;
                end
                if u24 > 0.008333333333333333 then
                    u25 = u25 + u24;
                    print("U19:", u19, "| U24:", u24)
                    local v87 = u19 * u24;
                    print("pass12")
                    local v88 = workspace:Raycast(u26, u27 * v87, v76);
                    local v89 = nil;
                    local v90 = nil;
                    local v91 = nil;
                    local v92
                    if v88 then
                        v89 = v88.Instance;
                        v92 = v88.Position;
                        v90 = v88.Normal;
                        v91 = v88.Material;
                    else
                        v92 = u26 + u27 * v87;
                    end;

                    print("pass13")
    
                    if settings.fastBullet then
                        if settings.currentTargetPart then
                            local RaycastParamsForTestRaycast = RaycastParams.new()
                            RaycastParamsForTestRaycast.FilterType = Enum.RaycastFilterType.Whitelist
                            RaycastParamsForTestRaycast.IgnoreWater = true
                            RaycastParamsForTestRaycast.FilterDescendantsInstances = {settings.currentTargetPart.Parent}
    
                            local TestRaycast = workspace:Raycast(workspace.CurrentCamera.CFrame.Position, (settings.currentTargetPart.Position - workspace.CurrentCamera.CFrame.Position).Unit * 99999, RaycastParamsForTestRaycast);
                            if TestRaycast then
                                v89 = TestRaycast.Instance;
                                v92 = TestRaycast.Position;
                                v90 = TestRaycast.Normal;
                                v91 = TestRaycast.Material;
                            else
                                v89 = settings.currentTargetPart
                                v92 = settings.currentTargetPart.Position
                                v90 = settings.currentTargetPart.CFrame.LookVector
                                v91 = settings.currentTargetPart.Material
                            end
                        end
                    end
                    print("pass14")
    
                    u28 = u28 + (u26 - v92).Magnitude;
                    if v83 then
                        local v93 = nil;
                        local v94 = nil;
                        v93 = (l__CurrentCamera__20.CFrame.Position - v92).Magnitude;
                        v94 = math.clamp(l__CurrentCamera__20.FieldOfView / 70, 0.38, 1.1);
                        if u28 < 200 then
                            local l__Magnitude__95 = (l__CurrentCamera__20.CFrame.Position - v92).Magnitude;
                            local v96 = math.clamp(v93 / 200, 0.1, 2.1) * u21 * v94;
                            local l__Magnitude__97 = (v84 - v92).Magnitude;
                            v83.Size = Vector3.new(v96, v96, v96) * (settings.bulletSizeMultiplier or 1);
                            v83.CFrame = CFrame.new(v84 + l__LookVector__15 * u28, (v92 - v84).Unit);
                        else
                            local l__Magnitude__98 = (l__CurrentCamera__20.CFrame.Position - v92).Magnitude;
                            local v99 = math.clamp(v93 / 200, 0.1, 2.1) * u21 * v94;
                            v83.Size = Vector3.new(v99, v99, v99) * (settings.bulletSizeMultiplier or 1);
                            v83.CFrame = CFrame.new(v92, u27);
                        end;
                    end;
                    print("pass15")
                    local v100 = "nil";
                    if v89 then
                        v100 = tostring((math.floor(v92.X))) .. tostring((math.floor(v92.Y))) .. tostring((math.floor(v92.Z))) .. tostring((math.floor(v90.X))) .. tostring((math.floor(v90.Y))) .. tostring((math.floor(v90.Z)));
                        if u29[v100] then
                            v92 = v92 - v90 * 0.1;
                        end;
                    end;
                    if v89 and not u29[v100] then
                        table.insert(u30, {
                            step = u24
                        });
                        local v101 = u1:FindDeepAncestor(v89, "Model");
                        if v89:FindFirstChild("RealParent") then
                            v101 = v89.RealParent.Value;
                        end;
                        if v89:GetAttribute("PassThrough", 2) then
                            table.insert(v77, v89);
                            v76.FilterDescendantsInstances = v77;
                            return;
                        end;
                        if v89:GetAttribute("PassThrough", 1) and v46 == nil then
                            table.insert(v77, v89);
                            v76.FilterDescendantsInstances = v77;
                            return;
                        end;
                        if v89:GetAttribute("Glass") then
                            u12.Impact(v89, v92, v90, v91, u27, "Ranged", true);
                            table.insert(v77, v89);
                            v76.FilterDescendantsInstances = v77;
                            return;
                        end;
                        if v89.Name == "Terrain" then
                            if u31 == false and v91 == Enum.Material.Water then
                                u31 = true;
                                v76.IgnoreWater = true;
                                u12.Impact(v89, v92, v90, v91, u27, "Ranged", true);
                                return;
                            end;
                            u12.Impact(v89, v92, v90, v91, u27, "Ranged", true);
                            u23:Disconnect();
                            if v83 then
                                if v83:FindFirstChild("Trail") then
                                    wait(v83.Trail.Lifetime);
                                end;
                                v83:Destroy();
                                return;
                            end;
                        elseif v101:FindFirstChild("Humanoid") then
                            if v101.PrimaryPart:FindFirstChild("Humanoid") then
                                local l__Anchored__102 = v101.PrimaryPart.Anchored;
                            end;
                            local l__p__103 = l__HumanoidRootPart__26.CFrame.p;
                            local v104 = u1:GetEstimatedCameraPosition(l__LocalPlayer__8);
                            local v105 = Ray.new(v104, (v81 - v104).Unit * 7500);
                            local v106 = v105.Origin - v92;
                            local l__Direction__107 = v105.Direction;
                            l__ProjectileInflict__13:FireServer(u17, u30, v89, nil, (v92 + (v106 - v106:Dot(l__Direction__107) / l__Direction__107:Dot(l__Direction__107) * l__Direction__107)).Y, v89.Position.X - v92.X, v89.Position.Z - v92.Z);
                            
                            if settings.createHitmarker then
                                settings.createHitmarker(CFrame.new(v92, v92 + v90))
                            end
                            
                            u12.Impact(v89, v92, v90, v91, u27, "Ranged", true);
                            u23:Disconnect();
                            if v83 then
                                if v83:FindFirstChild("Trail") then
                                    wait(v83.Trail.Lifetime);
                                end;
                                v83:Destroy();
                                return;
                            end;
                        elseif v101.ClassName == "Model" and v101.PrimaryPart ~= nil and v101.PrimaryPart:GetAttribute("Health") then
                            local v108 = v101.PrimaryPart:FindFirstChild("Humanoid") and v101.PrimaryPart.Anchored;
                            local l__p__109 = l__HumanoidRootPart__26.CFrame.p;
                            local v110 = u1:GetEstimatedCameraPosition(l__LocalPlayer__8);
                            local v111 = Ray.new(v110, (v81 - v110).Unit * 7500);
                            local v112 = v111.Origin - v92;
                            local l__Direction__113 = v111.Direction;
                            l__ProjectileInflict__13:FireServer(u17, u30, v89, v108, v92, (v92 + (v112 - v112:Dot(l__Direction__113) / l__Direction__113:Dot(l__Direction__113) * l__Direction__113)).Y, v89.Position.X - v92.X, v89.Position.Z - v92.Z);
                            if v101.Parent.Name ~= "SleepingPlayers" and v90 then
                                u12.Impact(v89, v92, v90, v91, u27, "Ranged", true);
                            end;

                            if settings.createHitmarker then
                                settings.createHitmarker(CFrame.new(v92, v92 + v90))
                            end

                            u23:Disconnect();
                            if v83 then
                                if v83:FindFirstChild("Trail") then
                                    wait(v83.Trail.Lifetime);
                                end;
                                v83:Destroy();
                                return;
                            end;
                        else
                            u12.Impact(v89, v92, v90, v91, u27, "Ranged", true);
                            local v114, v115, v116 = u1:Penetration(v89, v92, u27, u22);
                            u22 = v114;
                            if u22 > 0 then
                                u12.Impact(unpack(v116));
                                u19 = u19 * math.clamp(u22 / v48, 0.5, 1);
                                u26 = v115;
                                u29[v100] = true;
                                v76.FilterDescendantsInstances = v77;
                                return;
                            end;
                            u23:Disconnect();
                            if v83 then
                                if v83:FindFirstChild("Trail") then
                                    wait(v83.Trail.Lifetime);
                                end;
                                v83:Destroy();
                                return;
                            end;
                        end;
                    elseif u28 > 2500 or tick() - v78 > 60 then
                        u23:Disconnect();
                        if v83 then
                            if v83:FindFirstChild("Trail") then
                                wait(v83.Trail.Lifetime);
                            end;
                            v83:Destroy();
                            return;
                        end;
                    else
                        u26 = v92;
                        u19 = u19 - v39 * u19 ^ 2 * u24 ^ 2;
                        u27 = (u26 + u27 * 10000 - Vector3.new(0, v38 * u25 ^ 2, 0) - u26).Unit;
                        table.insert(u30, {
                            step = u24
                        });
                        u24 = 0;
                    end;

                    print("pass16")
                end;
            end);
        end;
        print("pass6")
        if v44 ~= nil then
            for v117 = 1, v44 do
                coroutine.wrap(v75)();
            end;
        else
            coroutine.wrap(v75)();
        end;
        return v54 / 200, v55 / 200, v52, v50;

    end)

    if suc then
        return err
    else
        print("ERROR INTERNALLY OCCURED", err)
    end
end;
return v1;
--[[ 8 10 pm]]
