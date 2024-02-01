from rest_framework import serializers
from Tom.models import SchedulingTasks

class SchedulingSerializer(serializers.ModelSerializer):
    task = serializers.CharField(max_length = 20)
    scheduled_id = serializers.integerField()
    scheduled_time = serializers.IntegerField()

    class Meta:
        model = SchedulingTasks
        fields = ("task", "scheduled_id", "scheduled_time")