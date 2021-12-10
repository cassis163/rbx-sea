return function(meshPart, scaleVector3)
	for _, descendant in pairs(meshPart:GetDescendants()) do
		if descendant:IsA("Bone") then
			local bone = descendant
			-- move bone local translation to part space, scale xyz in part space, then move back to bone parent space
			local parentCFrame
			if bone.Parent:IsA("Bone") then -- parent can be either the MeshPart or another Bone
				parentCFrame = bone.Parent.WorldCFrame
			else
				parentCFrame = bone.Parent.CFrame
			end
			local parentInPartCFrame = meshPart.CFrame:Inverse() * parentCFrame
			local parentInPartRotationCFrame = parentInPartCFrame - parentInPartCFrame.Position --rotation only
			local pivotOffsetInPartSpace = parentInPartRotationCFrame * bone.Position
			local scaledPivotOffsetInPartSpace = pivotOffsetInPartSpace * scaleVector3
			local partToParentRotationCFrame = parentInPartRotationCFrame:inverse()
			bone.Position = partToParentRotationCFrame * scaledPivotOffsetInPartSpace
		elseif descendant:IsA("Attachment") then
			-- attachments are always directly parented to the MeshPart
			local attachment = descendant
			attachment.Position = attachment.Position * scaleVector3
		end
	end
	meshPart.Size = meshPart.Size * scaleVector3
end
