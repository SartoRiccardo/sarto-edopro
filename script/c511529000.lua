--Sphere Field
local s,id=GetID()
function s.initial_effect(c)
	--Protection
	local ea=Effect.CreateEffect(c)
	ea:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	ea:SetType(EFFECT_TYPE_SINGLE)
	ea:SetCode(EFFECT_CANNOT_TO_GRAVE)
	c:RegisterEffect(ea)
	local eb=ea:Clone()
	eb:SetCode(EFFECT_CANNOT_TO_HAND)
	c:RegisterEffect(eb)
	local ec=ea:Clone()
	ec:SetCode(EFFECT_CANNOT_TO_DECK)
	c:RegisterEffect(ec)
	local ed=ea:Clone()
	ed:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	c:RegisterEffect(ed)

	--active
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PREDRAW)
	e1:SetRange(LOCATION_HAND+LOCATION_DECK)
	e1:SetCountLimit(1)
	e1:SetCondition(s.activecondition)
	e1:SetOperation(s.activeoperation)
	Duel.RegisterEffect(e1,0)

	--xyz summon
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_DISABLE_CHAIN)
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_REMOVED)
	--e3:SetCountLimit(1)
	--e3:SetCondition(s.normalsetcondition)
	e3:SetTarget(s.target)
	e3:SetOperation(s.operation)
	c:RegisterEffect(e3)
end
forbidden={}
forbidden[0]={}
forbidden[1]={}
function s.cflcon(e,tp,eg,ep,ev,re,r,rp)
	return re and re:GetHandler()~=e:GetHandler()
end
function s.cfl(e,tp,eg,ep,ev,re,r,rp)
	forbidden[tp]={}
end
function s.damtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re and re:GetHandler()~=e:GetHandler() and not re:GetHandler():IsCode(id) end
end
function s.damop(e,tp,eg,ep,ev,re,r,rp)
	local sg=eg
	if #sg>0 then
		Duel.SendtoDeck(sg,nil,0,REASON_RULE)
		if sg:IsExists(Card.IsControler,1,nil,tp) then
			Duel.ShuffleDeck(tp)
			forbidden[tp]={}
		end
	end
end

--active condition+operation
function s.activecondition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()==1
end
function s.activeoperation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_CARD,0,id)
	if not Duel.SelectYesNo(1-tp,aux.Stringid(id,0)) or not Duel.SelectYesNo(tp,aux.Stringid(id,0)) then
		local sg=Duel.GetMatchingGroup(Card.IsCode,tp,0x7f,0x7f,nil,id)
		Duel.SendtoDeck(sg,nil,-2,REASON_RULE)
		return
	end
	--place a card into removed zone
	Duel.Remove(c,POS_FACEUP,REASON_RULE)

end

s.listed_series={0x48}
function s.filter(c,e)
	return c:IsType(TYPE_MONSTER) and (not e or not c:IsImmuneToEffect(e))
end
function s.lvfilter(c,g)
	return g:IsExists(aux.FilterBoolFunction(Card.IsLevel,c:GetLevel()),1,c)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
		local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
		return #pg<=0 and g:IsExists(s.lvfilter,1,nil,g)
			and Duel.IsExistingMatchingCard(s.xyzfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.xyzfilter(c,e,tp)
	local m=c:GetMetatable(true)
	return c:IsSetCard(0x48) and not c:IsSetCard(0x1048) and not c:IsNumberS() -- Is a Number, but not a Number C or Number S.
		and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false)
		and m and 0 < m.xyz_number and m.xyz_number <= 100 -- Is not a Number 10X.
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local pg=aux.GetMustBeMaterialGroup(tp,Group.CreateGroup(),tp,nil,nil,REASON_XYZ)
	if not e:GetHandler():IsRelateToEffect(e) or #pg>0 then return end
	local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil,e)
	local sg=Duel.GetMatchingGroup(s.xyzfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	if #sg>0 and g:IsExists(s.lvfilter,1,nil,g) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg1=g:FilterSelect(tp,s.lvfilter,1,1,nil,g)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local mg2=g:FilterSelect(tp,aux.FilterBoolFunction(Card.IsLevel,mg1:GetFirst():GetLevel()),1,1,mg1)
		mg1:Merge(mg2)
		local xyz=sg:RandomSelect(tp,1):GetFirst()
		if Duel.SpecialSummonStep(xyz,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP) then
			--destroy
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SELF_DESTROY)
			e1:SetCondition(s.descon)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			xyz:RegisterEffect(e1)
			end
			Duel.Overlay(xyz,mg1)
			Duel.SpecialSummonComplete()
			xyz:CompleteProcedure()
	end
end
function s.descon(e)
	return e:GetHandler():GetOverlayCount()==0 and Duel.GetCurrentChain()==0
end
